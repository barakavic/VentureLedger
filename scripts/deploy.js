const { ethers } = require("hardhat");

async function main() {
    const [deployer, investor1] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // --- Deploy MockERC20 (our stablecoin) ---
    console.log("\nDeploying MockERC20 (MUSD)...");
    const MockERC20 = await ethers.getContractFactory("MockERC20");
    const initialSupplyMUSD = ethers.parseUnits("1000000", 18); // 1,000,000 tokens with 18 decimals
    const musd = await MockERC20.deploy("Mock USD", "MUSD", initialSupplyMUSD);
    await musd.waitForDeployment();
    const musdAddress = await musd.getAddress();
    console.log(`MockERC20 (MUSD) deployed to: ${musdAddress}`);

    // --- Deploy CompanyRegistry ---
    // #change: CompanyRegistry's constructor is empty, so no arguments are passed here.
    console.log("\nDeploying CompanyRegistry...");
    const CompanyRegistry = await ethers.getContractFactory("CompanyRegistry");
    const companyRegistry = await CompanyRegistry.deploy(); // No arguments for its constructor
    await companyRegistry.waitForDeployment();
    const companyRegistryAddress = await companyRegistry.getAddress();
    console.log(`CompanyRegistry deployed to: ${companyRegistryAddress}`);

    // --- Deploy CrowdfundingProject (DIRECTLY) ---
    // #change: CrowdfundingProject is deployed directly from the script, not by CompanyRegistry.
    // #change: We must provide ALL 7 arguments required by CrowdfundingProject's constructor.
    console.log("\nDeploying CrowdfundingProject...");
    const CrowdfundingProjectContract = await ethers.getContractFactory("CrowdfundingProject");

    // Define the arguments for CrowdfundingProject's constructor
    const projectOwnerCompany = deployer.address; // The deployer will be the owner company
    const projectName = "EcoFarm AI";
    const projectDescription = "AI-driven vertical farming system.";
    const fundingGoal = ethers.parseUnits("50000", 18); // Goal of 50,000 MUSD
    const durationInDays = 30; // 30 days for the project deadline
    const initialSharePrice = ethers.parseUnits("1", 18); // 1 MUSD per share

    const crowdfundingProject = await CrowdfundingProjectContract.deploy(
        projectOwnerCompany,
        projectName,
        projectDescription,
        fundingGoal,
        durationInDays,
        musdAddress,         // The stablecoin address
        initialSharePrice
    );
    await crowdfundingProject.waitForDeployment();
    const crowdfundingProjectAddress = await crowdfundingProject.getAddress();
    console.log(`CrowdfundingProject deployed to: ${crowdfundingProjectAddress}`);


    // --- Perform some initial interactions ---
    console.log("\n--- Performing Initial Interactions ---");

    // Give some MUSD to investor1
    const initialInvestorSupply = ethers.parseUnits("10000", 18); // Give Investor1 10,000 MUSD
    console.log(`Minting ${ethers.formatUnits(initialInvestorSupply, 18)} MUSD for Investor1 (${investor1.address})...`);
    await musd.mint(investor1.address, initialInvestorSupply);
    const investor1MusdBalance = await musd.balanceOf(investor1.address);
    console.log(`Investor1 MUSD Balance: ${ethers.formatUnits(investor1MusdBalance, 18)}`);

    // Register the company (the deployer's company)
    const companyName = "InnovateX Solutions";
    const companyDescription = "Developing AI-powered tools for sustainable agriculture.";
    console.log(`Registering company "${companyName}" by ${deployer.address}...`);
    await companyRegistry.registerCompany(companyName, companyDescription);
    console.log(`Company "${companyName}" registered.`);

    // --- Add the deployed CrowdfundingProject to the CompanyRegistry ---
    // #change: Call addProject on CompanyRegistry to link the deployed crowdfunding project.
    console.log(`Adding project "${projectName}" (${crowdfundingProjectAddress}) to CompanyRegistry for ${deployer.address}...`);
    await companyRegistry.addProject(deployer.address, crowdfundingProjectAddress, projectName);
    console.log("Project added to CompanyRegistry.");


    // --- Interact with the CrowdfundingProject (same as before) ---
    // Approve CrowdfundingProject to spend Investor1's MUSD
    const amountToApprove = ethers.parseUnits("500", 18); // Investor1 approves 500 MUSD
    console.log(`Investor1 (${investor1.address}) approving ${ethers.formatUnits(amountToApprove, 18)} MUSD for CrowdfundingProject (${crowdfundingProjectAddress})...`);
    await musd.connect(investor1).approve(crowdfundingProjectAddress, amountToApprove);
    console.log("Approval granted.");

    // Investor1 invests in the project
    const investmentAmount = ethers.parseUnits("200", 18); // Investor1 invests 200 MUSD
    console.log(`Investor1 (${investor1.address}) investing ${ethers.formatUnits(investmentAmount, 18)} MUSD in project...`);
    await crowdfundingProject.connect(investor1).invest(investmentAmount);
    console.log("Investment made.");

    const currentFunds = await crowdfundingProject.currentFunds();
    console.log(`Current project funds: ${ethers.formatUnits(currentFunds, 18)} MUSD`);
    const investorContribution = await crowdfundingProject.investorContributions(investor1.address);
    console.log(`Investor1's contribution: ${ethers.formatUnits(investorContribution, 18)} MUSD`);

    console.log("\nDeployment and initial interactions complete!");
    console.log("You can now write tests or build a frontend that interacts with these deployed contracts.");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });