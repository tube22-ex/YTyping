import type { Route } from "next";
import { LinkText } from "@/components/ui/typography";
import { trpc } from "@/trpc/server";

export const ByUser = async ({ userId }: { userId: string }) => {
  const profile = await trpc.user.profile.get.query({ userId: Number(userId) });

  return (
    <LinkText href={`/user/${userId}` as Route}>
      <span>{profile?.name}</span>
    </LinkText>
  );
};
