"use client";

import type { NextPage } from "next";
import { CheckCircleIcon, CodeBracketIcon } from "@heroicons/react/24/solid";

const Features: NextPage = () => {
  const deployedFeatures = [
    {
      title: "🏭 DEX Factory",
      address: "0xbbFfF35F9203707c80b46C3B8F8aCEAa7d12C67A",
      description: "Create multiple token pairs dynamically",
      whatItDoes: [
        "Deploy new trading pairs for any ERC20 tokens",
        "No need to redeploy contracts for new pairs",
        "Same pattern as Uniswap V2",
      ],
    },
    {
      title: "🛣️ DEX Router",
      address: "0x7141fF4Fe20D805D1520f8Bb5CFc88d311804Ab8",
      description: "Multi-hop swaps through multiple pairs",
      whatItDoes: [
        "Swap through multiple pairs in one transaction (e.g., TokenA → TokenB → TokenC)",
        "Save gas compared to multiple separate swaps",
        "Get better prices through optimal routing",
      ],
    },
    {
      title: "🗳️ DEX Governance",
      address: "0x3cA500678Cc4f245a47b04caB031623859431ecC",
      description: "Community voting for protocol changes",
      whatItDoes: [
        "1,000,000 DEXG governance tokens",
        "Create proposals to change trading fees",
        "Token holders vote on proposals (3-day voting period)",
      ],
    },
  ];

  return (
    <div className="flex items-center flex-col flex-grow pt-10">
      <div className="px-5 w-full max-w-6xl">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold mb-4">🚀 Deployed Features</h1>
          <p className="text-lg text-gray-400">Advanced DEX features live on Lisk Sepolia</p>
          <div className="badge badge-primary badge-lg mt-4">3 Contracts Deployed</div>
        </div>

        {/* Deployed Features */}
        <div className="grid grid-cols-1 gap-6 mb-12">
          {deployedFeatures.map((feature, index) => (
            <div key={index} className="card bg-base-200 shadow-xl">
              <div className="card-body">
                <h2 className="card-title text-2xl">{feature.title}</h2>

                <a
                  href={`https://sepolia-blockscout.lisk.com/address/${feature.address}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="badge badge-accent gap-2"
                >
                  <CodeBracketIcon className="w-4 h-4" />
                  {feature.address.slice(0, 10)}...{feature.address.slice(-8)}
                </a>

                <p className="text-gray-400 mb-4">{feature.description}</p>

                <div className="space-y-2">
                  <p className="font-semibold">What it does:</p>
                  {feature.whatItDoes.map((item, i) => (
                    <div key={i} className="flex items-start gap-2">
                      <CheckCircleIcon className="w-5 h-5 text-success mt-0.5 flex-shrink-0" />
                      <span className="text-sm">{item}</span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Why These Features Matter */}
        <div className="card bg-gradient-to-r from-primary to-secondary text-primary-content shadow-xl mb-12">
          <div className="card-body">
            <h2 className="card-title text-2xl mb-4">Why These Features Matter</h2>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div>
                <h3 className="font-bold mb-2">Factory Pattern</h3>
                <p className="text-sm">
                  Enables unlimited trading pairs without redeploying contracts. Used by Uniswap, Sushiswap,
                  PancakeSwap.
                </p>
              </div>

              <div>
                <h3 className="font-bold mb-2">Router System</h3>
                <p className="text-sm">
                  Trade any token to any other token in a single transaction. Better prices through optimal routing.
                </p>
              </div>

              <div>
                <h3 className="font-bold mb-2">Governance</h3>
                <p className="text-sm">
                  Decentralized decision-making. Community controls protocol parameters like trading fees.
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Technical Info */}
        <div className="card bg-base-200 shadow-xl mb-12">
          <div className="card-body">
            <h2 className="card-title text-xl mb-4">Technical Details</h2>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="flex justify-between p-3 bg-base-300 rounded">
                <span className="font-semibold">Network:</span>
                <span className="">Lisk Sepolia</span>
              </div>
              <div className="flex justify-between p-3 bg-base-300 rounded">
                <span className="font-semibold">Chain ID:</span>
                <span className="">4202</span>
              </div>
              <div className="flex justify-between p-3 bg-base-300 rounded">
                <span className="font-semibold">AMM Model:</span>
                <span className="">Constant Product (x * y = k)</span>
              </div>
              <div className="flex justify-between p-3 bg-base-300 rounded">
                <span className="font-semibold">Trading Fee:</span>
                <span className="">0.3%</span>
              </div>
            </div>
          </div>
        </div>

        {/* Contract Links */}
        <div className="card bg-base-200 shadow-xl">
          <div className="card-body">
            <h2 className="card-title mb-4">Verify on Block Explorer</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {deployedFeatures.map((feature, index) => (
                <a
                  key={index}
                  href={`https://sepolia-blockscout.lisk.com/address/${feature.address}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="btn btn-primary btn-block"
                >
                  View {feature.title}
                </a>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Features;
