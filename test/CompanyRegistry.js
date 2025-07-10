const { expect } = require("chai");
const { ethers } = require("hardat"); 

describe("CompanyRegistry", function (){
    let MockERC20, musd;
    let CompanyRegistry,companyRegistry;
    let CrowdfundingProject, crowdfundingProject;
    let deployer, investor1, company2;

    beforeEach(async function(){
        [deployer, investor1, company2] = await ethers.getSigners();


        //Deploying mockERC20
        MockERC20 = await ethers.getContractFactory("MockERC20");


        //Deploying with a large initial supply for testing
        musd = await MockERC20.deploy("Mock USD", "MUSD", ethers.parseUnits("1000000",18));
        await musd.waitForDeployment();
        const musdAddress = await musd.getAddress();


        //Deploying CompanyRegistry
        CompanyRegistry = await ethers.getContractFactory("Company Registry");
        CompanyRegistry = await CompanyRegistry.deploy();
        await companyRegistry.waitForDeployment();

        //Deploying CrowdFunding directly
        /* Verification in later tests will use the CompanyRegistry's addProject */
        CrowdfundingProject = await ethers.getContractFactory("CrowdfundingProject");
        const projectName = "EcoFarm AI";
        const projectDescription = "AI-driven vertical farming system";
        const fundingGoal = ethers.parseUnits("50000", 18);
        const durationInDays = 30;
        const initialSharePrice = ethers.parseUnits("1", 18);

        crowdfundingProject = await CrowdfundingProject.deploy(

            deployer.address,
            projectName,
            projectDescription,
            fundingGoal,
            durationInDays,
            musdAddress,
            initialSharePrice

        );
        await crowdfundingProject.waitForDeployment();



    });

    it("Should allow a company to register", async function () {
        const companyName = "Innovatex Solutions";
        const companyDescription = "Developing AI_powered tools for sustainable agriculture";


        await companyRegistry.connect(deployer).registerCompany(companyName, companyDescription);

        const companyDetails = await companyRegistry.companies(deployer.address);

        expect(companyDetails.isRegistered).to.equal(true);
        expect(companyDetails.name).to.equal(companyName);
        expect (companyDetails.description).to.equal(companyDescription);
        expect (companyDetails.companyAddress).to.equal(deployer.address);
        expect(companyDetails.projects.legnth).to.equal(0);
        
    })
})