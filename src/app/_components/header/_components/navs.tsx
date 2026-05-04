"use client";
import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { useSession } from "@/lib/auth-client";
import { LeftMenus, SiteLogo } from "./left-menus";
import { ActiveUsersSheet } from "./right-menus/active-user/active-users-sheet";
import { RegisterLogoutButton } from "./right-menus/auth/register-logout-button";
import { SignInMenu } from "./right-menus/auth/sign-in-menu";
import { HamburgerMenu } from "./right-menus/hamburger-menu";
import { NewMapPopover } from "./right-menus/new-map-popover";
import { NotificationSheet } from "./right-menus/notification-sheet";
import { UserMenu } from "./right-menus/user-menu";

export const LeftNav = () => {
  const pathname = usePathname();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <div className="flex items-center gap-5">
      <SiteLogo />
      {mounted && pathname !== "/user/register" && <LeftMenus />}
    </div>
  );
};

export const RightNav = () => {
  const { data: session } = useSession();
  const pathname = usePathname();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const isRegisterPage = pathname === "/user/register";

  if (!mounted) return <div className="flex select-none items-center gap-2 h-10 w-20" />;

  return (
    <div className="flex select-none items-center gap-2">
      <div id="right-nav-icons" className="flex items-center gap-2">
        {session?.user?.name && (
          <>
            <ActiveUsersSheet />
            <NotificationSheet />
            <NewMapPopover />
          </>
        )}
      </div>
      {!isRegisterPage && (
        <>
          <HamburgerMenu className="md:hidden" />
          <RightDropDownMenu className="hidden md:flex" />
        </>
      )}
      {isRegisterPage && <RegisterLogoutButton />}
    </div>
  );
};

const RightDropDownMenu = ({ className }: { className: string }) => {
  const { data: session } = useSession();
  if (session?.user?.name) {
    return <UserMenu userName={session.user.name} className={className} userId={session.user.id} />;
  }

  return <SignInMenu className={className} />;
};
