import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployDEXFactory: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  console.log("\n🏭 Deploying DEXFactory...");

  await deploy("DEXFactory", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  console.log("✅ DEXFactory deployed successfully!");
};

export default deployDEXFactory;
deployDEXFactory.tags = ["DEXFactory", "V2"];
