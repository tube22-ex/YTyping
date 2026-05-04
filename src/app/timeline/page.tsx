import { Suspense } from "react";
import { loadResultListSearchParams } from "@/lib/search-params/result-list";
import { HydrateClient, prefetch, staticApi } from "@/trpc/server";
import { JotaiProvider } from "./_components/provider";
import { UsersResultList } from "./_components/result-list";
import { SearchContent } from "./_components/search-content";

export const revalidate = 60;

export default async function Home({ searchParams }: PageProps<"/timeline">) {
  const params = loadResultListSearchParams(await searchParams);

  // Prefetch data using the ISR-safe staticApi to keep the page cachable
  await prefetch(staticApi.result.list.get.infiniteQueryOptions(params));

  return (
    <HydrateClient>
      <JotaiProvider params={params}>
        <div className="mx-auto w-full space-y-8 lg:w-5xl">
          <SearchContent />
          <Suspense
            fallback={
              <div className="space-y-4">
                {[...Array(5)].map((_, i) => (
                  // biome-ignore lint/suspicious/noArrayIndexKey: 静的なスケルトン表示のため
                  <div key={i} className="h-32 w-full animate-pulse rounded-lg bg-card" />
                ))}
              </div>
            }
          >
            <UsersResultList />
          </Suspense>
        </div>
      </JotaiProvider>
    </HydrateClient>
  );
}
