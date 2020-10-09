pragma solidity ^0.5.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "./ComptrollerInterface.sol";
import "./CTokenInterface.sol";

// contract to 
// 1. lend Dai
// 2. Withdraw Dai
// 3. Borrow Bat with Dai collateral
// 4. Repay borrowed Bat 

contract Compound {
    
    IERC20 dai;
    CTokenInterface cDai;
    IERC20 bat;
    CTokenInterface cBat;
    ComptrollerInterface comptroller;
    
    constructor(
                address _dai,
                address _cDai,
                address _bat,
                address _cBat,
                address _comptroller) public {
                    
                    dai = IERC20(_dai);
                    cDai= CTokenInterface(_cDai);
                    bat=IERC20(_bat);
                    cBat=CTokenInterface(_cBat);
                    comptroller=ComptrollerInterface(_comptroller);
                }
                
    function deposit() external {
        dai.approve(address(cDai),10);
        cDai.mint(10);
    }   
    
    function withdraw() external{
        uint balance = cDai.balanceOf(address(this));
        cDai.redeem(balance);
    }
    
    function  borrow() external{
         dai.approve(address(cDai),10);
         cDai.mint(10);
         
         address[] markets = new address[1];
         markets[0]=cDai;
         
         cDai.enterMarket(markets);
         
         cBat.borrow(1);
    }
    
    function repay() external{
        bat.approve(address(cBat),1.01); // bat + interest
        cBat.repayBorrow(1);
        
        // optional to withdraw collateral
        uint balance = cDai.balanceOf(address(this));
        cDai.redeem(balance);
    }
    
}