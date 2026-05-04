import "server-only";
import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import type { TRPCQueryOptions } from "@trpc/tanstack-react-query";
import { createTRPCOptionsProxy } from "@trpc/tanstack-react-query";
import { headers } from "next/headers";
import type { ReactNode } from "react";
import { cache } from "react";
import { auth } from "@/lib/auth";
import type { AppRouter } from "@/server/api/root";
import { appRouter } from "@/server/api/root";
import { createCallerFactory, createTRPCContext } from "@/server/api/trpc";
import { makeQueryClient } from "./query-client";
import "server-only";

/**
 * This wraps the `createTRPCContext` helper and provides the required context for the tRPC API when
 * handling a tRPC call from a React Server Component.
 */
const createContext = cache(async () => {
  const heads = new Headers(await headers());
  heads.set("x-trpc-source", "rsc");

  return createTRPCContext({ headers: heads, auth });
});

/**
 * ISR-safe context that doesn't call dynamic APIs (headers/cookies).
 * Use this for prefetching data in static (ISR) pages.
 */
const createStaticContext = cache(async () => {
  const heads = new Headers();
  heads.set("x-trpc-source", "rsc-static");

  return createTRPCContext({
    headers: heads,
    auth: {
      ...auth,
      // Override getSession/api to avoid calling dynamic cookies()
      api: { ...auth.api, getSession: async () => null },
    },
  });
});

const getQueryClient = cache(makeQueryClient);
export const getCaller = cache(() => createCallerFactory(appRouter)(createContext));
export const getStaticCaller = cache(() => createCallerFactory(appRouter)(createStaticContext));

export const trpc = createTRPCOptionsProxy<AppRouter>({
  router: appRouter,
  ctx: createContext,
  queryClient: getQueryClient,
});

/**
 * ISR-safe tRPC client for Server Components.
 */
export const staticApi = createTRPCOptionsProxy<AppRouter>({
  router: appRouter,
  ctx: createStaticContext,
  queryClient: getQueryClient,
});

export function HydrateClient(props: { children: ReactNode }) {
  const queryClient = getQueryClient();
  return <HydrationBoundary state={dehydrate(queryClient)}>{props.children}</HydrationBoundary>;
}

// biome-ignore lint/suspicious/noExplicitAny: <queryOptions 型をうまく表現できないため any を使用>
export async function prefetch<T extends ReturnType<TRPCQueryOptions<any>>>(queryOptions: T) {
  const queryClient = getQueryClient();
  if (queryOptions.queryKey[1]?.type === "infinite") {
    // biome-ignore lint/suspicious/noExplicitAny: <queryOptions 型をうまく表現できないため any を使用>
    await queryClient.prefetchInfiniteQuery(queryOptions as any);
  } else {
    await queryClient.prefetchQuery(queryOptions);
  }
}
