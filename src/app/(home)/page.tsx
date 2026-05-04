import dynamic from "next/dynamic";
import { Suspense } from "react";
import { loadMapListSearchParams } from "@/app/(home)/_feature/controls/search-params";
import { HydrateClient, prefetch, staticApi } from "@/trpc/server";
import { MapListControls } from "./_feature/controls/controls";
import { MapList } from "./_feature/map-list";
import { JotaiProvider } from "./_feature/provider";

export const revalidate = 60;

export default async function Home({ searchParams }: PageProps<"/">) {
  const mapListQueryParams = loadMapListSearchParams(await searchParams);

  // Prefetch data using the ISR-safe staticApi to keep the page cachable
  await prefetch(staticApi.map.list.get.infiniteQueryOptions(mapListQueryParams));

  return (
    <HydrateClient>
      <JotaiProvider>
        <div className="mx-auto max-w-7xl space-y-3 lg:px-8">
          <Suspense fallback={<div className="h-20 animate-pulse bg-card" />}>
            <MapListControls />
          </Suspense>
          <Suspense
            fallback={
              <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
                {[...Array(6)].map((_, i) => (
                  // biome-ignore lint/suspicious/noArrayIndexKey: 静的なスケルトンのため
                  <div key={i} className="h-40 w-full animate-pulse rounded-lg bg-card" />
                ))}
              </div>
            }
          >
            <MapList />
          </Suspense>
        </div>
      </JotaiProvider>
    </HydrateClient>
  );
}
