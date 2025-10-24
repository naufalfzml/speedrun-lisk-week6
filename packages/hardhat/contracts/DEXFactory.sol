// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleDEX.sol";

/**
 * @title DEXFactory
 * @notice Factory contract to create and manage multiple DEX pairs
 * @dev Inspired by Uniswap V2 Factory pattern
 */
contract DEXFactory {
    // Mapping to track all created pairs: token0 => token1 => pair address
    mapping(address => mapping(address => address)) public getPair;

    // Array of all pairs created
    address[] public allPairs;

    // Events
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256 pairCount
    );

    /**
     * @notice Create a new DEX pair for two tokens
     * @param tokenA Address of first token
     * @param tokenB Address of second token
     * @return pair Address of the created DEX pair
     */
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair)
    {
        require(tokenA != tokenB, "DEXFactory: IDENTICAL_ADDRESSES");

        // Sort tokens to ensure consistent pair addressing
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);

        require(token0 != address(0), "DEXFactory: ZERO_ADDRESS");
        require(getPair[token0][token1] == address(0), "DEXFactory: PAIR_EXISTS");

        // Deploy new SimpleDEX contract
        SimpleDEX dex = new SimpleDEX(token0, token1);
        pair = address(dex);

        // Populate mapping in both directions
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair;
        allPairs.push(pair);

        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    /**
     * @notice Get total number of pairs created
     * @return Total pair count
     */
    function allPairsLength() external view returns (uint256) {
        return allPairs.length;
    }
}
