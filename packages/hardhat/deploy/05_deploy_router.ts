import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployDEXRouter: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy, get } = hre.deployments;

  // Get DEXFactory address
  const factory = await get("DEXFactory");

  console.log("\n🛣️  Deploying DEXRouter...");
  console.log("  Factory address:", factory.address);

  await deploy("DEXRouter", {
    from: deployer,
    args: [factory.address],
    log: true,
    autoMine: true,
  });

  console.log("✅ DEXRouter deployed successfully!");
};

export default deployDEXRouter;
deployDEXRouter.tags = ["DEXRouter", "V2"];
deployDEXRouter.dependencies = ["DEXFactory"];
