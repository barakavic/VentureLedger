// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract CompanyRegistry {


    struct Company{
        address companyAddress;
        string name;
        string description;
        bool isRegistered;

        // Array To store all the crowdfunding contracts started by this company
        address[] projects;
    }


    mapping (address => Company) public companies;

    address[] public registeredCompanyAddresses;

    event CompanyRegistered(address indexed companyAddress, string name);

    event ProjectAdded(address indexed companyAddress, address indexed projectAddress, string projectName);


    constructor(){
        //No complex setup right at deployment
    }

    function registerCompany(string memory _name, string memory _description)  public {
        

        require(!companies[msg.sender].isRegistered, "Company is already Registered");


        companies[msg.sender] = Company(
            msg.sender,
            _name,
            _description,
            true,
            new address[](0)//Initialising an empty array for projects 
        );


        registeredCompanyAddresses.push(msg.sender);

        emit CompanyRegistered(msg.sender, _name);
    }


    function getCompanyDetails(address _companyAddress) 
    public 
    view
    returns (string memory name, string memory description, bool isRegistered, address[] memory projects)
    {
        Company storage company = companies[_companyAddress];

        return (company.name, company.description, company.isRegistered, company.projects);
    }

    function addProject(address _companyAddress, address _projectAddress, string memory _projectName) public{


        require(companies[_companyAddress].isRegistered, "Company not Registered");


        companies[_companyAddress].projects.push(_projectAddress);

        emit ProjectAdded(_companyAddress, _projectAddress, _projectName);
    }





}