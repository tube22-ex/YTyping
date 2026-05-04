import { headers } from "next/headers";
import { getSession } from "@/lib/auth";
import { getCaller } from "@/trpc/server";
import { JotaiProvider } from "./jotai-provider";

export const JotaiProviderWrapper = async ({ children }: { children: React.ReactNode }) => {
  const userAgent = (await headers()).get("user-agent") ?? "";
  const session = await getSession();
  const caller = getCaller();
  const userOptions = session ? await caller.user.option.getForSession() : null;

  return (
    <JotaiProvider userOptions={userOptions} userAgent={userAgent}>
      {children}
    </JotaiProvider>
  );
};
