import { getSession } from "@/lib/auth";
import { cn } from "@/lib/utils";
import { HydrateClient, prefetch, trpc } from "@/trpc/server";
import { LeftNav, RightNav } from "./_components/navs";

interface HeaderProps {
  className: string;
}

export const Header = async ({ className }: HeaderProps) => {
  const session = await getSession();
  if (session?.user?.id) {
    prefetch(trpc.user.stats.getMyPpRank.queryOptions());
  }

  return (
    <HydrateClient>
      <header id="header" className={cn("bg-header-background", className)}>
        <nav className="mx-4 flex items-center justify-between pt-px md:mx-10 lg:mx-36">
          <LeftNav />
          <RightNav />
        </nav>
      </header>
    </HydrateClient>
  );
};
