import { Header } from "@/app/_components/header/header";
import "@/styles/globals.css";
import { Analytics } from "@vercel/analytics/next";
import type { Metadata, Viewport } from "next";
import { Noto_Sans_JP } from "next/font/google";
import { NuqsAdapter } from "nuqs/adapters/next/app";
import { TooltipProvider } from "@/components/ui/tooltip";
import { getSession } from "@/lib/auth";
import { THEME_LIST } from "@/styles/const";
import TRPCProvider from "@/trpc/provider";
import { LinkProgressProvider } from "./_components/link-progress-provider";
import { SessionProvider } from "./_components/session-provider";
import { ThemeProvider } from "./_components/theme-provider";
import { Suspense } from "react";
import { JotaiProviderWrapper } from "./_components/jotai-provider-wrapper";
import dynamic from "next/dynamic";

const ConfirmDialogHost = dynamic(() => import("@/components/ui/confirm-dialog").then((m) => m.ConfirmDialogHost));
const OverlayHost = dynamic(() => import("@/components/ui/overlay").then((m) => m.OverlayHost));
const Toaster = dynamic(() => import("@/components/ui/sonner").then((m) => m.Toaster));
const ClearSelectionOnNavigate = dynamic(() => import("@/utils/hooks/clear-selection-on-navigate").then((m) => m.ClearSelectionOnNavigate));
const PreviewYouTubePlayer = dynamic(() => import("./_components/preview-youtube-player").then((m) => m.PreviewYouTubePlayer));
const UserScriptInit = dynamic(() => import("./user-script").then((m) => m.UserScriptInit));

const notoSansJP = Noto_Sans_JP({
  subsets: ["latin"],
  weight: ["400", "500", "700"],
  display: "swap",
});

export const metadata: Metadata = {
  title: "YTyping",
  description: "YouTube Typing Game",
  manifest: "/manifest.json",
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: "YTyping",
  },
  formatDetection: {
    telephone: false,
  },
};

export const viewport: Viewport = {
  themeColor: "#000000",
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
};

export default async function RootLayout({ children }: LayoutProps<"/">) {
  const session = await getSession();

  return (
    <html lang="ja" className={notoSansJP.className} suppressHydrationWarning>
      <head>
        <meta charSet="UTF-8" />
        <meta name="robots" content="noindex, nofollow" />
      </head>
      <body>
        <NuqsAdapter>
          <ThemeProvider
            attribute="class"
            defaultTheme="default"
            enableColorScheme
            disableTransitionOnChange
            themes={[...THEME_LIST.dark.map((theme) => theme.class), ...THEME_LIST.light.map((theme) => theme.class)]}
          >
            <TRPCProvider>
              <LinkProgressProvider>
                <TooltipProvider delayDuration={600}>
                  <SessionProvider session={session}>
                    <Header className="fixed z-50 h-10 w-screen" session={session} />
                    <Suspense
                      fallback={
                        <main className="min-h-screen pt-12 pb-6 md:pt-16" id="main_content">
                          <div className="mx-auto max-w-7xl space-y-3 lg:px-8">
                            <div className="h-20 animate-pulse bg-card" />
                            <div className="h-96 animate-pulse bg-card" />
                          </div>
                        </main>
                      }
                    >
                      <JotaiProviderWrapper>
                        <main className="min-h-screen pt-12 pb-6 md:pt-16" id="main_content">
                          {children}
                          <Analytics />
                        </main>
                        <PreviewYouTubePlayer />
                      </JotaiProviderWrapper>
                    </Suspense>
                  </SessionProvider>
                </TooltipProvider>
              </LinkProgressProvider>
            </TRPCProvider>
          </ThemeProvider>
        </NuqsAdapter>
        <Toaster />
        <ConfirmDialogHost />
        <OverlayHost />
        <ClearSelectionOnNavigate />
        <UserScriptInit />
      </body>
    </html>
  );
}
