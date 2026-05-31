import type { NextConfig } from "next";

const isMainnet = process.env.NEXT_PUBLIC_NETWORK === "mainnet";

/**
 * Allowed Soroban RPC origins vary by network.
 * Extend the connect-src directive if you use an alternative RPC endpoint.
 */
const rpcOrigin = isMainnet
  ? "https://mainnet.sorobanrpc.com"
  : "https://soroban-testnet.stellar.org";

/**
 * Content Security Policy for VestFlow.
 *
 * `connect-src` covers XHR / fetch / WebSocket connections made by the
 * browser — this is the critical directive for Soroban RPC calls.
 */
const cspHeader = [
  `default-src 'self'`,
  `script-src 'self' 'unsafe-inline' 'unsafe-eval'`,
  `style-src 'self' 'unsafe-inline'`,
  `img-src 'self' data: blob:`,
  `font-src 'self'`,
  `connect-src 'self' ${rpcOrigin} https://horizon.stellar.org https://horizon-testnet.stellar.org`,
  `frame-ancestors 'none'`,
].join("; ");

const nextConfig: NextConfig = {
  async headers() {
    return [
      {
        // Apply CSP to all routes
        source: "/(.*)",
        headers: [
          {
            key: "Content-Security-Policy",
            value: cspHeader,
          },
        ],
      },
    ];
  },
};

export default nextConfig;
