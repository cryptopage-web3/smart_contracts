// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

/// @title Contract of Page.RulesList
/// @notice This contract contains a list of rules.
/// @dev Constants from this list are used to access rules settings.
library  RulesList {

    // Community Joining Rules
    bytes32 public constant COMMUNITY_JOINING_RULES = keccak256(abi.encode("PAGE.COMMUNITY_JOINING_RULES"));
    bytes32 public constant OPEN_TO_ALL = keccak256(abi.encode("OPEN_TO_ALL"));
    bytes32 public constant BADGE_TOKENS_USING = keccak256(abi.encode("BADGE_TOKENS_USING"));
    bytes32 public constant WHEN_JOINING_PAYMENT = keccak256(abi.encode("WHEN_JOINING_PAYMENT"));
    bytes32 public constant PERIODIC_PAYMENT = keccak256(abi.encode("PERIODIC_PAYMENT"));

    // Community Edit Moderators Rules
    bytes32 public constant COMMUNITY_EDIT_MODERATOR_RULES = keccak256(abi.encode("PAGE.COMMUNITY_ADD_MODERATOR_RULES"));
    bytes32 public constant NO_EDIT_MODERATOR = keccak256(abi.encode("NO_EDIT_MODERATOR"));
    bytes32 public constant EDIT_AFTER_VOTED = keccak256(abi.encode("EDIT_AFTER_VOTED"));
    bytes32 public constant EDIT_ONLY_SUPER_ADMIN = keccak256(abi.encode("EDIT_ONLY_SUPER_ADMIN"));
    bytes32 public constant EDIT_BY_CREATOR = keccak256(abi.encode("EDIT_BY_CREATOR"));

    // Community Post Placing Rules
    bytes32 public constant POST_PLACING_RULES = keccak256(abi.encode("PAGE.POST_PLACING_RULES"));
    bytes32 public constant FREE_FOR_EVERYONE = keccak256(abi.encode("FREE_FOR_EVERYONE"));
    bytes32 public constant PAYMENT_FROM_EVERYONE = keccak256(abi.encode("PAYMENT_FROM_EVERYONE"));
    bytes32 public constant COMMUNITY_MEMBERS_ONLY = keccak256(abi.encode("COMMUNITY_MEMBERS_ONLY"));
    bytes32 public constant COMMUNITY_FOUNDERS_ONLY = keccak256(abi.encode("COMMUNITY_FOUNDERS_ONLY"));

    // Community Accepting Post Rules
    bytes32 public constant ACCEPTING_POST_RULES = keccak256(abi.encode("PAGE.ACCEPTING_POST_RULES"));
    bytes32 public constant ACCEPTING_FOR_EVERYONE = keccak256(abi.encode("ACCEPTING_FOR_EVERYONE"));
    bytes32 public constant ACCEPTING_FOR_COMMUNITY_MEMBERS_ONLY = keccak256(abi.encode("ACCEPTING_FOR_COMMUNITY_MEMBERS_ONLY"));
    bytes32 public constant ACCEPTING_AFTER_MODERATOR_APPROVED = keccak256(abi.encode("ACCEPTING_AFTER_MODERATOR_APPROVED"));
    bytes32 public constant ACCEPTING_FOR_COMMUNITY_FOUNDERS_ONLY = keccak256(abi.encode("ACCEPTING_FOR_COMMUNITY_FOUNDERS_ONLY"));

    // Community Post Reading Rules
    bytes32 public constant POST_READING_RULES = keccak256(abi.encode("PAGE.POST_READING_RULES"));
    bytes32 public constant READING_FOR_EVERYONE = keccak256(abi.encode("READING_FOR_EVERYONE"));
    bytes32 public constant READING_ENCRYPTED = keccak256(abi.encode("READING_ENCRYPTED"));

    // Community Post Commenting Rules
    bytes32 public constant POST_COMMENTING_RULES = keccak256(abi.encode("PAGE.POST_COMMENTING_RULES"));
    bytes32 public constant COMMENTING_MANY_TIMES = keccak256(abi.encode("COMMENTING_MANY_TIMES"));
    bytes32 public constant COMMENTING_ONE_TIME = keccak256(abi.encode("COMMENTING_ONE_TIME"));
    bytes32 public constant COMMENTING_WITH_BADGE_TOKENS = keccak256(abi.encode("COMMENTING_WITH_BADGE_TOKENS"));

    // Change Visibility Content Rules
    bytes32 public constant CHANGE_VISIBILITY_CONTENT_RULES = keccak256(abi.encode("PAGE.CHANGE_VISIBILITY_CONTENT_RULES"));
    bytes32 public constant NO_CHANGE_VISIBILITY = keccak256(abi.encode("NO_CHANGE_VISIBILITY"));
    bytes32 public constant CHANGE_VISIBILITY_USING_VOTING = keccak256(abi.encode("CHANGE_VISIBILITY_USING_VOTING"));
    bytes32 public constant CHANGE_VISIBILITY_ONLY_MODERATORS = keccak256(abi.encode("CHANGE_VISIBILITY_ONLY_MODERATORS"));
    bytes32 public constant CHANGE_VISIBILITY_ONLY_OWNER = keccak256(abi.encode("CHANGE_VISIBILITY_ONLY_OWNER"));

    // Community Moderation Rules
    bytes32 public constant MODERATION_RULES = keccak256(abi.encode("PAGE.MODERATION_RULES"));
    bytes32 public constant NO_MODERATION = keccak256(abi.encode("NO_MODERATION"));
    bytes32 public constant MODERATION_USING_VOTING = keccak256(abi.encode("MODERATION_USING_VOTING"));
    bytes32 public constant MODERATION_USING_MODERATORS = keccak256(abi.encode("MODERATION_USING_MODERATORS"));

    // Community Gas Compensation Rules
    bytes32 public constant GAS_COMPENSATION_RULES = keccak256(abi.encode("PAGE.GAS_COMPENSATION_RULES"));
    bytes32 public constant NO_GAS_COMPENSATION = keccak256(abi.encode("NO_GAS_COMPENSATION"));
    bytes32 public constant GAS_COMPENSATION_FOR_COMMUNITY = keccak256(abi.encode("GAS_COMPENSATION_FOR_COMMUNITY"));
    bytes32 public constant GAS_COMPENSATION_FOR_AUTHOR = keccak256(abi.encode("GAS_COMPENSATION_FOR_AUTHOR"));

    // Community Advertising Placement Rules
    bytes32 public constant ADVERTISING_PLACEMENT_RULES = keccak256(abi.encode("PAGE.ADVERTISING_PLACEMENT_RULES"));
    bytes32 public constant NO_ADVERTISING = keccak256(abi.encode("NO_ADVERTISING"));
    bytes32 public constant ADVERTISING_BY_FOUNDERS = keccak256(abi.encode("ADVERTISING_BY_FOUNDERS"));
    bytes32 public constant ADVERTISING_BY_MODERATORS = keccak256(abi.encode("ADVERTISING_BY_MODERATORS"));
    bytes32 public constant ADVERTISING_BY_SPECIAL_USER = keccak256(abi.encode("ADVERTISING_BY_SPECIAL_USER"));

    // Community Profit Distribution Rules
    bytes32 public constant PROFIT_DISTRIBUTION_RULES = keccak256(abi.encode("PAGE.PROFIT_DISTRIBUTION_RULES"));
    bytes32 public constant DISTRIBUTION_USING_BADGE_TOKENS = keccak256(abi.encode("DISTRIBUTION_USING_BADGE_TOKENS"));
    bytes32 public constant DISTRIBUTION_FOR_EVERYONE = keccak256(abi.encode("DISTRIBUTION_FOR_EVERYONE"));
    bytes32 public constant DISTRIBUTION_USING_VOTING = keccak256(abi.encode("DISTRIBUTION_USING_VOTING"));
    bytes32 public constant DISTRIBUTION_FOR_FOUNDERS = keccak256(abi.encode("DISTRIBUTION_FOR_FOUNDERS"));

    // Community Reputation Management Rules
    bytes32 public constant REPUTATION_MANAGEMENT_RULES = keccak256(abi.encode("PAGE.REPUTATION_MANAGEMENT_RULES"));
    bytes32 public constant REPUTATION_NOT_USED = keccak256(abi.encode("REPUTATION_NOT_USED"));
    bytes32 public constant REPUTATION_CAN_CHANGE = keccak256(abi.encode("REPUTATION_CAN_CHANGE"));

    // Community Post Transferring Rules
    bytes32 public constant POST_TRANSFERRING_RULES = keccak256(abi.encode("PAGE.POST_TRANSFERRING_RULES"));
    bytes32 public constant TRANSFERRING_DENIED = keccak256(abi.encode("TRANSFERRING_DENIED"));
    bytes32 public constant TRANSFERRING_WITH_VOTING = keccak256(abi.encode("TRANSFERRING_WITH_VOTING"));
    bytes32 public constant TRANSFERRING_ONLY_AUTHOR = keccak256(abi.encode("TRANSFERRING_ONLY_AUTHOR"));

    function version() external pure returns (string memory) {
        return "1";
    }
}
