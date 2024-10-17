// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ClaimFaucet} from "./ClaimFaucet.sol";
import {IERC20} from "./IERC20.sol";

contract ClaimFaucetFactory {

    struct DeployedContractInfo {
        address deployer;
        address deployedContract;
    }

    mapping(address => DeployedContractInfo[]) allUserDeployedContracts;

    DeployedContractInfo[] allContracts;

    function deployClaimFaucet(string memory _name, string memory _symbol)
        external
        returns (address contractAdress_)
    {
        require(msg.sender != address(0), "Zero not allowed");
        address _address = address(new ClaimFaucet(_name, _symbol));
        contractAdress_ = _address;

        DeployedContractInfo memory _deployedContract;
        _deployedContract.deployer = msg.sender;
        _deployedContract.deployedContract = _address;

        allUserDeployedContracts[msg.sender].push(_deployedContract);

        allContracts.push(_deployedContract);
    }

    function getAllContractDeployed()
        external
        view
        returns (DeployedContractInfo[] memory)
    {
         require(msg.sender != address(0), "Zero not allowed");
        return allContracts;
    }

    function getUserDeployedContracts()
        external
        view
        returns (DeployedContractInfo[] memory)
    {
         require(msg.sender != address(0), "Zero not allowed");
        return allUserDeployedContracts[msg.sender];
    }

    function getUserDeployedContractsByIndex(uint8 _index)
        external
        view
        returns (address deployer_, address deployedContract_)
    {
        require(msg.sender != address(0), "Zero not allowed");
        require(
            _index < allUserDeployedContracts[msg.sender].length,
            "Out of bound"
        );

        DeployedContractInfo
            memory _deployedContract = allUserDeployedContracts[msg.sender][
                _index
            ];

        deployer_ = _deployedContract.deployer;
        deployedContract_ = _deployedContract.deployedContract;
    }

    function getLengthOfDeployedContracts() external view returns (uint256) {
         require(msg.sender != address(0), "Zero not allowed");
        uint256 lens = allContracts.length;

        return lens;
    }

    function getInfoFromContract(address _contractAddr) external view returns (string memory, string memory) {
        return (IERC20(_contractAddr).getTokenName(), IERC20(_contractAddr).getSymbol());

    }

    function getBalanceFromDeployedContract(address _contractAddr) external view returns (uint256 balance_) {
        uint256 userBal = IERC20(_contractAddr).balanceOf(msg.sender);
        return userBal;
    }

    function claimFaucetFromContract(address _claimFaucet) external {
        ClaimFaucet(_claimFaucet).claimToken(msg.sender);
    }

}