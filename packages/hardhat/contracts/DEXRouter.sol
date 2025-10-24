// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DEXFactory.sol";
import "./SimpleDEX.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title DEXRouter
 * @notice Router contract for multi-hop swaps through multiple pairs
 * @dev Enables swapping through path: TokenA -> TokenB -> TokenC
 */
contract DEXRouter {
    DEXFactory public immutable factory;

    constructor(address _factory) {
        require(_factory != address(0), "Invalid factory address");
        factory = DEXFactory(_factory);
    }

    /**
     * @notice Swap exact tokens for tokens through a specified path
     * @param amountIn Input amount
     * @param minAmountOut Minimum output amount (slippage protection)
     * @param path Array of token addresses (e.g., [TokenA, TokenB, TokenC])
     * @param to Recipient address
     * @return amounts Array of amounts for each swap in the path
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 minAmountOut,
        address[] calldata path,
        address to
    ) external returns (uint256[] memory amounts) {
        require(path.length >= 2, "DEXRouter: INVALID_PATH");
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;

        // Transfer initial tokens from sender to first pair
        IERC20(path[0]).transferFrom(
            msg.sender,
            factory.getPair(path[0], path[1]),
            amountIn
        );

        // Execute swaps along the path
        for (uint256 i = 0; i < path.length - 1; i++) {
            address pair = factory.getPair(path[i], path[i + 1]);
            require(pair != address(0), "DEXRouter: PAIR_NOT_EXISTS");

            SimpleDEX dex = SimpleDEX(pair);

            // Get swap amount
            amounts[i + 1] = dex.getSwapAmount(path[i], amounts[i]);

            // Determine recipient (next pair or final recipient)
            address recipient = i < path.length - 2
                ? factory.getPair(path[i + 1], path[i + 2])
                : to;

            // Execute swap
            dex.swap(path[i], amounts[i], 0); // minAmountOut checked at the end

            // Transfer output to recipient
            IERC20(path[i + 1]).transfer(recipient, amounts[i + 1]);
        }

        // Check final output meets minimum
        require(
            amounts[amounts.length - 1] >= minAmountOut,
            "DEXRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
    }

    /**
     * @notice Get amounts out for a given input through a path
     * @param amountIn Input amount
     * @param path Array of token addresses
     * @return amounts Array of output amounts for each step
     */
    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts)
    {
        require(path.length >= 2, "DEXRouter: INVALID_PATH");
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;

        for (uint256 i = 0; i < path.length - 1; i++) {
            address pair = factory.getPair(path[i], path[i + 1]);
            require(pair != address(0), "DEXRouter: PAIR_NOT_EXISTS");

            SimpleDEX dex = SimpleDEX(pair);
            amounts[i + 1] = dex.getSwapAmount(path[i], amounts[i]);
        }
    }
}
