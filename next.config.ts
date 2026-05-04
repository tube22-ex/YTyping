// @ts-check

import withPWAInit from "@ducanh2912/next-pwa";
import type { NextConfig } from "next";

const withPWA = withPWAInit({
  dest: "public",
  disable: process.env.NODE_ENV === "development",
  register: true,
  skipWaiting: true,
  reloadOnOnline: true,
  swMinify: false, // ビルド高速化のために圧縮をオフに
  cacheOnFrontEndNav: false, // 初回ロード時の負荷軽減
  aggressiveFrontEndNavCaching: false, // 負荷軽減
  runtimeCaching: [
    {
      urlPattern: /^https:\/\/fonts\.(?:gstatic|googleapis)\.com\/.*/i,
      handler: "CacheFirst",
      options: {
        cacheName: "google-fonts",
        expiration: {
          maxEntries: 4,
          maxAgeSeconds: 365 * 24 * 60 * 60, // 1 year
        },
      },
    },
    {
      urlPattern: /\.(?:eot|otf|ttc|ttf|woff|woff2|font.css)$/i,
      handler: "StaleWhileRevalidate",
      options: {
        cacheName: "static-font-assets",
      },
    },
    {
      urlPattern: /\.(?:jpg|jpeg|gif|png|svg|ico|webp)$/i,
      handler: "StaleWhileRevalidate",
      options: {
        cacheName: "static-image-assets",
      },
    },
    {
      urlPattern: /\/_next\/image\?url=.+/i,
      handler: "StaleWhileRevalidate",
      options: {
        cacheName: "next-image",
      },
    },
    {
      urlPattern: /\.(?:js)$/i,
      handler: "StaleWhileRevalidate",
      options: {
        cacheName: "static-js-assets",
      },
    },
    {
      urlPattern: /\.(?:css|less)$/i,
      handler: "StaleWhileRevalidate",
      options: {
        cacheName: "static-style-assets",
      },
    },
    {
      urlPattern: /^https?:\/\/localhost:3000\/?$/i,
      handler: "StaleWhileRevalidate",
      options: {
        cacheName: "index-page",
        expiration: {
          maxEntries: 1,
          maxAgeSeconds: 24 * 60 * 60, // 24 hours
        },
      },
    },
    {
      urlPattern: /\/(type|rankings|user|manual|bookmarks|timeline|edit)\/.*/i,
      handler: "StaleWhileRevalidate",
      options: {
        cacheName: "dynamic-pages",
        expiration: {
          maxEntries: 200,
          maxAgeSeconds: 24 * 60 * 60, // 24 hours
        },
      },
    },
  ],
});

const nextConfig: NextConfig = {
  cacheComponents: false,
  experimental: {
    scrollRestoration: true,
  },
  reactStrictMode: false,
  typedRoutes: true,
  reactCompiler: true,
  productionBrowserSourceMaps: false,
  typescript: {
    ignoreBuildErrors: true,
  },
  compiler: {
    removeConsole: process.env.NODE_ENV === "production",
  },
  images: {
    minimumCacheTTL: 2678400, // 31 days
    remotePatterns: [
      {
        protocol: "https",
        hostname: "i.ytimg.com",
        pathname: "/vi/**",
      },
      {
        protocol: "https",
        hostname: "i.ytimg.com",
        pathname: "/vi_webp/**",
      },
    ],
  },
};

// biome-ignore lint/style/noDefaultExport: required default export
export default withPWA(nextConfig);
