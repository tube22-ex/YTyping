"use client";
import { useEffect } from "react";
import { setUserOptions } from "@/lib/atoms/global-atoms";
import { useSession } from "@/lib/auth-client";
import { trpc } from "@/trpc/client";

export function StateSync() {
  const { data: session } = useSession();
  const { data: options } = trpc.user.option.getForSession.useQuery(undefined, {
    enabled: !!session,
  });

  useEffect(() => {
    if (options) {
      setUserOptions(options);
    }
  }, [options]);

  return null;
}
