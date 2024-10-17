import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ClaimFaucetFactoryModule = buildModule("ClaimFaucetFactoryModule", (m) => {
  const claimfaucetfactory = m.contract("ClaimFaucetFactory");
 
    return { claimfaucetfactory };
  
});

export default ClaimFaucetFactoryModule;