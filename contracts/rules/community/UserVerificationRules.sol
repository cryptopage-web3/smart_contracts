// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/IUserVerificationRules.sol";
import "./interfaces/IFractalRegistry.sol";

/// @title Contract of Page.UserVerificationRules
/// @notice This contract contains rules.
/// @dev .
contract UserVerificationRules is IUserVerificationRules, Ownable {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.USER_VERIFICATION_RULES;
    string public fractalListId;

    IRegistry public registry;
    IFractalRegistry public fractalRegistry;

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    /// Only after setting these parameters will it be possible to activate this rule
    function setFractalParams(address _fractalRegistry, string memory _fractalListId) external onlyOwner {
        fractalRegistry = IFractalRegistry(_fractalRegistry);
        fractalListId = _fractalListId;
        renounceOwnership();
    }

    function validate(address _communityId, address _user) external view override returns(bool) {
        require(owner() == address(0), "UserVerificationRules: contract parameters are not set");

        if (isActiveRule(_communityId, RulesList.NO_VERIFICATION)) {
            return true;
        }
        if (isActiveRule(_communityId, RulesList.USING_VERIFICATION)) {
            require(
                isVerificationUser(_user),
                "UserVerificationRules: the user did not pass verification"
            );
        }

        return true;
    }

    function isVerificationUser(address _user) private view returns(bool) {
        bytes32 userId = fractalRegistry.getFractalId(_user);
        return fractalRegistry.isUserInList(userId, fractalListId);
    }

    function isActiveRule(address _communityId, bytes32 _ruleName) private view returns(bool) {
        return (
        ICommunityBlank(_communityId).isLinkedRule(GROUP_RULE, RULES_VERSION, _ruleName)
        && IRule(registry.rule()).isSupportedRule(GROUP_RULE, RULES_VERSION, _ruleName)
        );
    }
}
