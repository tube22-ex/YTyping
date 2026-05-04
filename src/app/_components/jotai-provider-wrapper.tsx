import { JotaiProvider } from "./jotai-provider";

export const JotaiProviderWrapper = ({ children }: { children: React.ReactNode }) => {
  return <JotaiProvider>{children}</JotaiProvider>;
};
