// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


interface ICommunityBlank {

    function creator() external view returns (address);

    function linkPlugin(bytes32 _pluginName, uint256 _version) external;

    function unLinkPlugin(bytes32 _pluginName, uint256 _version) external;

    function isLinkedPlugin(bytes32 _pluginName, uint256 _version) external view returns (bool);

    function claimERC20Token(IERC20 _token, address _receiver, uint256 _amount) external;
}