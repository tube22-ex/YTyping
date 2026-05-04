import { atom, useAtomValue } from "jotai";

export const bookmarkedMapIdsAtom = atom<number[]>([]);

export const useIsBookmarked = (mapId: number | null) => {
  const bookmarkedMapIds = useAtomValue(bookmarkedMapIdsAtom);
  if (mapId === null) return false;
  return bookmarkedMapIds.includes(mapId);
};
