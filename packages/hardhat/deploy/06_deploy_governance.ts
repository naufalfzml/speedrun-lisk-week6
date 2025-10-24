import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployDEXGovernance: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  console.log("\n🗳️  Deploying DEXGovernance...");

  await deploy("DEXGovernance", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  console.log("✅ DEXGovernance deployed successfully!");
};

export default deployDEXGovernance;
deployDEXGovernance.tags = ["DEXGovernance", "V2"];
