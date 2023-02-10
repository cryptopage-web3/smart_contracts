import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

import setupContracts from "../../setup-contracts";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;
const { parseUnits, randomBytes } = ethers.utils;

describe("Test Comment basic functionality", function () {

    let owner: SignerWithAddress,
        creator: SignerWithAddress,
        third: SignerWithAddress;
    let version, ruleList, pluginList;
    let registry, rule, executor, bank, communityData, postData, commentData;
    let createdCommunity, account;
    let token, nft, soulBound;

    before(async function () {
        ({
            owner, creator, third,
            version, ruleList, pluginList,
            registry, rule, executor,bank,
            token, nft, soulBound,
            communityData, postData, commentData, account,
            createdCommunity
        } = await setupContracts());

    })

    it("Should write/read comment", async function () {
        let communityAddress = createdCommunity.address;

        let id = ethers.utils.formatBytes32String("20");
        let data = defaultAbiCoder.encode([ "address" ], [communityAddress]);
        await executor.connect(third).run(id, pluginList.COMMUNITY_JOIN(), version, data);

        id = ethers.utils.formatBytes32String("21");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_JOIN(), version, data);

        let postHash = "#1 hash for post";
        let tags = ["1", "2"];

        data = defaultAbiCoder.encode(
            [ "address", "address", "string", "uint256", "string[]", "bool", "bool" ],
            [communityAddress, third.address, postHash, 0, tags, false, true]
        );

        id = ethers.utils.formatBytes32String("22");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_POST(), version, data);

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        let postId = postIds[0].toNumber();

        let commentHash1 = "#1 hash for comment";
        data = defaultAbiCoder.encode(
            [ "address", "uint256", "address", "string", "bool", "bool", "bool", "bool" ],
            [communityAddress, postId, third.address, commentHash1, true, false, false, true]
        );
        id = ethers.utils.formatBytes32String("23");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_COMMENT(), version, data);

        let commentHash2 = "#2 hash for comment";
        data = defaultAbiCoder.encode(
            [ "address", "uint256", "address", "string", "bool", "bool", "bool", "bool" ],
            [communityAddress, postId, creator.address, commentHash2, false, true, false, true]
        );
        id = ethers.utils.formatBytes32String("24");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_WRITE_COMMENT(), version, data);

        let pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_COMMENT(), version);
        let pluginFactory = await ethers.getContractFactory("contracts/plugins/comment/Read.sol:Read");
        let plugin = await pluginFactory.attach(pluginAddress);

        let commentInfo = await plugin.connect(third).read(postId, 1);
        expect(communityAddress).to.equal(commentInfo.communityId);
        expect(third.address).to.equal(commentInfo.owner);
        expect(commentHash1).to.equal(commentInfo.ipfsHash);

        commentInfo = await plugin.connect(third).read(postId, 2);
        expect(communityAddress).to.equal(commentInfo.communityId);
        expect(creator.address).to.equal(commentInfo.owner);
        expect(commentHash2).to.equal(commentInfo.ipfsHash);

        pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_POST(), version);
        pluginFactory = await ethers.getContractFactory("contracts/plugins/post/Read.sol:Read");
        plugin = await pluginFactory.attach(pluginAddress);

        let postInfo = await plugin.connect(third).read(postId);
        expect(postInfo.upCount).to.equal(
            BigNumber.from(1)
        );
        expect(postInfo.downCount).to.equal(
            BigNumber.from(1)
        );
        expect(postInfo.commentCount).to.equal(
            BigNumber.from(2)
        );
    });

    it("Should burn comment", async function () {
        let communityAddress = createdCommunity.address;

        let postHash = "#2 hash for post";
        let tags = ["1", "2"];

        let data = defaultAbiCoder.encode(
            [ "address", "address", "string", "uint256", "string[]", "bool", "bool" ],
            [communityAddress, third.address, postHash, 0, tags, false, true]
        );

        let id = ethers.utils.formatBytes32String("26");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_POST(), version, data);

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        let postId = postIds[1].toNumber();

        let commentHash1 = "#3 hash for comment";
        data = defaultAbiCoder.encode(
            [ "address", "uint256", "address", "string", "bool", "bool", "bool", "bool" ],
            [communityAddress, postId, third.address, commentHash1, true, false, false, true]
        );
        id = ethers.utils.formatBytes32String("27");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_COMMENT(), version, data);

        let commentHash2 = "#4 hash for comment";
        data = defaultAbiCoder.encode(
            [ "address", "uint256", "address", "string", "bool", "bool", "bool", "bool" ],
            [communityAddress, postId, creator.address, commentHash2, false, true, false, true]
        );
        id = ethers.utils.formatBytes32String("28");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_WRITE_COMMENT(), version, data);

        let pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_COMMENT(), version);
        let pluginFactory = await ethers.getContractFactory("contracts/plugins/comment/Read.sol:Read");
        let plugin = await pluginFactory.attach(pluginAddress);

        let commentId = 1;

        let commentInfo = await plugin.connect(third).read(postId, commentId);
        expect(true).to.equal(commentInfo.isView);

        data = defaultAbiCoder.encode(
            [ "address", "address", "bool" ],
            [communityAddress, creator.address, true]
        );
        id = ethers.utils.formatBytes32String("29");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_EDIT_MODERATORS(), version, data);

        await rule.connect(owner).enableRule(ruleList.MODERATION_RULES(), version, ruleList.MODERATION_USING_MODERATORS());
        await createdCommunity.connect(owner).linkRule(ruleList.MODERATION_RULES(), version, ruleList.MODERATION_USING_MODERATORS());

        data = defaultAbiCoder.encode(
            [ "uint256", "uint256" ],
            [postId, commentId ]
        );
        id = ethers.utils.formatBytes32String("291");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_BURN_COMMENT(), version, data);

        commentInfo = await plugin.connect(third).read(postId, commentId);
        expect(false).to.equal(commentInfo.isView);

    });

    it("Should change visibility comment", async function () {
        let communityAddress = createdCommunity.address;

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        let postId = postIds[0].toNumber();

        let commentHash = "#3 hash for comment";
        let data = defaultAbiCoder.encode(
            [ "address", "uint256", "address", "string", "bool", "bool", "bool", "bool" ],
            [communityAddress, postId, third.address, commentHash, false, false, false, true]
        );
        let id = ethers.utils.formatBytes32String("292");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_COMMENT(), version, data);

        let pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_COMMENT(), version);
        let pluginFactory = await ethers.getContractFactory("contracts/plugins/comment/Read.sol:Read");
        let plugin = await pluginFactory.attach(pluginAddress);

        let commentId = 3;

        let commentInfo = await plugin.connect(third).read(postId, commentId);
        expect(true).to.equal(commentInfo.isView);

        let pathName = "contracts/plugins/comment/ChangeVisibility.sol:ChangeVisibility";
        let pluginName = pluginList.COMMUNITY_CHANGE_VISIBILITY_COMMENT();
        pluginFactory = await ethers.getContractFactory(pathName);
        let pluginContract = await pluginFactory.deploy(registry.address);
        await pluginContract.deployed();
        await registry.setPlugin(pluginName, version, pluginContract.address);

        await createdCommunity.connect(owner).linkPlugin(pluginList.COMMUNITY_CHANGE_VISIBILITY_COMMENT(), version);

        pathName = "contracts/rules/community/ChangeVisibilityContentRules.sol:ChangeVisibilityContentRules";
        let ruleName = keccak256(defaultAbiCoder.encode(["string"], ["PAGE.CHANGE_VISIBILITY_CONTENT_RULES"]));
        let rulesFactory =  await ethers.getContractFactory(pathName);
        let rulesContract = await rulesFactory.deploy(registry.address);
        await rule.setRuleContract(ruleName, version, rulesContract.address);

        await rule.connect(owner).enableRule(ruleList.CHANGE_VISIBILITY_CONTENT_RULES(), version, ruleList.CHANGE_VISIBILITY_ONLY_OWNER());
        await createdCommunity.connect(owner).linkRule(ruleList.CHANGE_VISIBILITY_CONTENT_RULES(), version, ruleList.CHANGE_VISIBILITY_ONLY_OWNER());


        data = defaultAbiCoder.encode(
            [ "uint256", "uint256", "bool" ],
            [postId, commentId, false ]
        );
        id = ethers.utils.formatBytes32String("293");
        await executor.connect(third).run(id, pluginList.COMMUNITY_CHANGE_VISIBILITY_COMMENT(), version, data);

        commentInfo = await plugin.connect(third).read(postId, commentId);
        //console.log("commentInfo = ", commentInfo);
        expect(false).to.equal(commentInfo.isView);

    });

    it("Should gas compensation comment", async function () {
        let communityAddress = createdCommunity.address;

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        let postId = postIds[0].toNumber();

        let pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_COMMENT(), version);
        let pluginFactory = await ethers.getContractFactory("contracts/plugins/comment/Read.sol:Read");
        let readPlugin = await pluginFactory.attach(pluginAddress);

        let commentId = 2;

        let commentInfo = await readPlugin.connect(third).read(postId, commentId);
        expect(false).to.equal(commentInfo.isGasCompensation);

        let pathName = "contracts/plugins/comment/GasCompensation.sol:GasCompensation";
        let pluginName = pluginList.COMMUNITY_COMMENT_GAS_COMPENSATION();
        pluginFactory = await ethers.getContractFactory(pathName);
        let pluginContract = await pluginFactory.deploy(registry.address);
        await pluginContract.deployed();

        await registry.setPlugin(pluginName, version, pluginContract.address);
        await createdCommunity.connect(owner).linkPlugin(pluginList.COMMUNITY_COMMENT_GAS_COMPENSATION(), version);

        pathName = "contracts/plugins/bank/BalanceOf.sol:BalanceOf";
        pluginName = pluginList.BANK_BALANCE_OF();
        pluginFactory = await ethers.getContractFactory(pathName);
        pluginContract = await pluginFactory.deploy(registry.address);
        await pluginContract.deployed();

        await registry.setPlugin(pluginName, version, pluginContract.address);
        await createdCommunity.connect(owner).linkPlugin(pluginList.BANK_BALANCE_OF(), version);

        pathName = "contracts/rules/community/GasCompensationRules.sol:GasCompensationRules";
        let ruleName = keccak256(defaultAbiCoder.encode(["string"], ["PAGE.GAS_COMPENSATION_RULES"]));
        let rulesFactory =  await ethers.getContractFactory(pathName);
        let rulesContract = await rulesFactory.deploy(registry.address);
        await rule.setRuleContract(ruleName, version, rulesContract.address);

        await rule.connect(owner).enableRule(ruleList.GAS_COMPENSATION_RULES(), version, ruleList.GAS_COMPENSATION_FOR_OWNER());
        await createdCommunity.connect(owner).linkRule(ruleList.GAS_COMPENSATION_RULES(), version, ruleList.GAS_COMPENSATION_FOR_OWNER());

        pluginAddress = await registry.getPluginContract(pluginList.BANK_BALANCE_OF(), version);
        pluginFactory = await ethers.getContractFactory("contracts/plugins/bank/BalanceOf.sol:BalanceOf");
        let balancePlugin = await pluginFactory.attach(pluginAddress);
        let balanceOf = await balancePlugin.connect(third).read(third.address);
        expect(balanceOf == 0).to.be.true;

        let commentId0 = 1;

        let data = defaultAbiCoder.encode(
            [ "uint256", "uint256[]" ],
            [ postId, [commentId0,commentId] ]
        );
        let id = ethers.utils.formatBytes32String("294");

        let tx = await executor.connect(third).run(id, pluginList.COMMUNITY_COMMENT_GAS_COMPENSATION(), version, data);

        commentInfo = await readPlugin.connect(third).read(postId, commentId);
        expect(true).to.equal(commentInfo.isGasCompensation);

        balanceOf = await balancePlugin.connect(third).read(third.address);
        expect(balanceOf > 0).to.be.true;
    });

});