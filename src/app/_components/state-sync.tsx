"use client";
import { useQuery } from "@tanstack/react-query";
import { useSetAtom } from "jotai";
import { useEffect } from "react";
import { bookmarkedMapIdsAtom } from "@/lib/atoms/bookmark-atoms";
import { setUserOptions } from "@/lib/atoms/global-atoms";
import { useSession } from "@/lib/auth-client";
import { useTRPC } from "@/trpc/provider";

export function StateSync() {
  const { data: session } = useSession();
  const trpc = useTRPC();
  const setBookmarkedMapIds = useSetAtom(bookmarkedMapIdsAtom);

  const { data: options } = useQuery(
    trpc.user.option.getForSession.queryOptions(undefined, {
      enabled: !!session,
    }),
  );

  const { data: bookmarkIds } = useQuery(
    trpc.map.bookmark.listItem.getBookmarkedMapIds.queryOptions(undefined, {
      enabled: !!session,
    }),
  );

  useEffect(() => {
    if (options) {
      setUserOptions(options);
    }
  }, [options]);

  useEffect(() => {
    if (bookmarkIds) {
      setBookmarkedMapIds(bookmarkIds);
    }
  }, [bookmarkIds, setBookmarkedMapIds]);

  return null;
}
