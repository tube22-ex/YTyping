"use client";
import { useQuery } from "@tanstack/react-query";
import { useEffect } from "react";
import { setUserOptions } from "@/lib/atoms/global-atoms";
import { useSession } from "@/lib/auth-client";
import { useTRPC } from "@/trpc/provider";

export function StateSync() {
  const { data: session } = useSession();
  const trpc = useTRPC();
  const { data: options } = useQuery(
    trpc.user.option.getForSession.queryOptions(undefined, {
      enabled: !!session,
    }),
  );

  useEffect(() => {
    if (options) {
      setUserOptions(options);
    }
  }, [options]);

  return null;
}
