import { Suspense } from "react";
import { getSession } from "@/lib/auth";
import { loadMapListSearchParams } from "@/app/(home)/_feature/controls/search-params";
import { HydrateClient, prefetch, trpc } from "@/trpc/server";
import { JotaiProvider } from "./_feature/provider";
import dynamic from "next/dynamic";

const MapListControls = dynamic(() => import("./_feature/controls/controls").then((m) => m.MapListControls));
const MapList = dynamic(() => import("./_feature/map-list").then((m) => m.MapList));

export const revalidate = 600; // 10 minutes

export default async function Home({ searchParams }: PageProps<"/">) {
  const mapListQueryParams = loadMapListSearchParams(await searchParams);
  const session = await getSession();

  prefetch(trpc.map.list.get.infiniteQueryOptions(mapListQueryParams));
  if (session) {
    prefetch(trpc.map.bookmark.lists.getForSession.queryOptions());
  }

  return (
    <HydrateClient>
      <JotaiProvider>
        <div className="mx-auto max-w-7xl space-y-3 lg:px-8">
          <Suspense fallback={<div className="h-20 animate-pulse bg-card" />}>
            <MapListControls />
          </Suspense>
          <Suspense fallback={<div className="h-96 animate-pulse bg-card" />}>
            <MapList />
          </Suspense>
        </div>
      </JotaiProvider>
    </HydrateClient>
  );
}
