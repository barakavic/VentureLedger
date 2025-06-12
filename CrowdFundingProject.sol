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

    uint256 public initialSharePrice;

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


constructor(
    address _ownerCompany,
    string memory _projectName,
    string memory _projectDescription,
    uint256 _fundingGoal,
    uint256 _durationInDays,
    address _stablecoinAddress,
    uint256 _initialSharePrice


){
    require(_ownerCompany != address(0), "Owner Company Address Cannot be zero");
    require (_fundingGoal > 0,"Funding Goal must be greater than zero");
    require(_durationInDays > 0,  "Duration Must be greater than zero");
    require(_stablecoinAddress != address(0), "StableCoin Address cannot be zero");
    require(_initialSharePrice > 0, "Initial share price must be greater than zero");


    ownerCompany = _ownerCompany;
    projectName = _projectName;
    projectDescription = _projectDescription;
    fundingGoal = _fundingGoal;
    deadline = block.timestamp + (_durationInDays * 1 days);
    projectActive = true;
    goalAchieved = false;
    fundsReleased = false;
    fundsRefunded = false;

    stablecoin = IERC20(_stablecoinAddress);
    initialSharePrice = _initialSharePrice;

    emit ProjectStarted(
        ownerCompany,
        projectName,
        fundingGoal,
        deadline,
        _stablecoinAddress,
        _initialSharePrice
    );







}


// Core crowdfunding Functions

function invest(uint _amount) public{
    require(projectActive, "Project is not active");
    require(block.timestamp < deadline, "Funding Period has ended");
    require(_amount > 0, "Investment amount must be greater than zero");

    uint256 sharesToRecieve = _amount / initialSharePrice;
    require(sharesToRecieve > 0, "Investment too small for any shares");

    bool success = stablecoin.transferFrom(msg.sender, address(this), _amount);
    require(success, "Stablecoin transfer failed");

    raisedAmount += _amount;
    shares[msg.sender] += sharesToRecieve;
    investorContributions[msg.sender] += _amount;

    emit InvestmentMade(msg.sender, _amount, sharesToRecieve);
}

function releaseFunds() public {
    require(msg.sender == ownerCompany, "Only the owner company can release funds");
    require(block.timestamp >= deadline, "Funding period has not ended yet");
    require(raisedAmount >= fundingGoal, "Funding goal not met");
    require(!fundsReleased, "Funds already Released");
    require(!fundsRefunded, "funds already Refunded");

    goalAchieved = true;
    fundsReleased = true;
    projectActive = false;

    bool success = stablecoin.transfer(ownerCompany, raisedAmount);
    require(success, "Failed to release funds to the company");


    emit FundsReleased(ownerCompany, raisedAmount);
    emit ProjectClosed(true, raisedAmount);
}

function claimRefund() public{
    require(block.timestamp >= deadline, "Funding Period has not ended yet");
    require(raisedAmount < fundingGoal, "Funding goal wasa met");
    require(!fundsReleased, "Funds already released");
    require(!fundsRefunded, "Funds not refunded");
    require(investorContributions[msg.sender] > 0, "No contribution to refund for this investor");

    uint256 refundAmount = investorContributions[msg.sender];

    bool success = stablecoin.transfer(msg.sender, refundAmount);
    require(success, "Failed to refund investor");

    shares[msg.sender] = 0;
    investorContributions[msg.sender] = 0;

    emit FundsRefunded(msg.sender, refundAmount);



}

function getShares(address _investor) public view returns (uint256){
    return shares[_investor];
}

}
