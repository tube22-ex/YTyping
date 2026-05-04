import dynamic from "next/dynamic";
import { Suspense } from "react";
import { loadMapListSearchParams } from "@/app/(home)/_feature/controls/search-params";
import { HydrateClient, prefetch, staticApi } from "@/trpc/server";
import { JotaiProvider } from "./_feature/provider";

const MapListControls = dynamic(() => import("./_feature/controls/controls").then((m) => m.MapListControls));
const MapList = dynamic(() => import("./_feature/map-list").then((m) => m.MapList));

export const revalidate = 60;

export default async function Home({ searchParams }: PageProps<"/">) {
  const mapListQueryParams = loadMapListSearchParams(await searchParams);

  // Prefetch data using the ISR-safe staticApi to keep the page cachable
  prefetch(staticApi.map.list.get.infiniteQueryOptions(mapListQueryParams));

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
