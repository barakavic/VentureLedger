//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CrowdfundingProject {
    // === 1. state variables ===

    address public ownerCompany;
    string public projectName;
    string public projectDescription;
    uint256 public fundingGoal;
    uint256 public deadline;
    uint256 public raisedAmount;
    bool public projectActive;
    bool public goalAchieved;
    bool public fundsReleased;
    bool public fundsRefunded;

    IERC20 public stablecoin;

    mapping(address => uint256) public shares;
    mapping (address => uint256) public investorContributions;

    uint256 public initialSHarePrice;

    event ProjectStarted(
        address indexed _ownerCompany,
        string _projectName,
        uint256 _fundingGoal,
        uint256 _deadline,
        address _stableCoinAddress,
        uint256 _initialSharePrice
    );

    event InvestmentMade(address indexed _investor, uint256 _amount, uint256 _sharesRecieved);
    event GoalAchieved(uint256 _totalRaised);
    event FundsReleased(address _to, uint256 _amount);
    event FundsRefunded(address _investor,uint256 _amount);
    event ProjectClosed(bool _goalAchieved, uint256 _finalAmount);
    
}


