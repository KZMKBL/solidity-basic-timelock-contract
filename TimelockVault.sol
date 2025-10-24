// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TimelockVault
 * @dev Sözleşme sahibinin yatırdığı ERC-20 token'larını belirli bir süre boyunca kilitler.
 * Bu, proje fonlarının güvenli bir şekilde saklandığını göstermek için kullanılan temel bir mekanizmadır.
 */
contract TimelockVault is Ownable {
    // Kilitleme süresi: Örneğin 30 gün = 30 * 24 * 60 * 60 saniye
    uint256 public constant LOCK_DURATION = 30 days; 
    
    // Çekimin yapılabileceği en erken zaman damgası (timestamp)
    uint256 public unlockTime;
    
    // Hangi token'ın kilitlendiğini tutar
    IERC20 public immutable token;

    /**
     * @dev Sözleşme dağıtıldığında çalışır.
     * @param _tokenAddress Kilitlenecek ERC-20 token'ının adresi.
     */
    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
        // Kilitleme süresi başlangıçta ayarlanmaz, ilk yatırma anında ayarlanır.
        // Ancak bu örnekte, dağıtıldığı anı başlangıç alalım.
        unlockTime = block.timestamp + LOCK_DURATION; 
    }

    /**
     * @dev Belirtilen miktarda token'ı sözleşmeye yatırır ve kilitler.
     * Bu fonksiyonu yalnızca sahip çağırabilir (Ownable'dan miras alınmıştır).
     * @param amount Yatırılacak token miktarı.
     */
    function lockTokens(uint256 amount) public onlyOwner {
        // Kontrol: Yatırma miktarının sıfırdan büyük olması gerekir
        require(amount > 0, "TV: Amount must be greater than zero");
        
        // Bu adresten token'ları sözleşmeye transfer et
        bool success = token.transferFrom(msg.sender, address(this), amount);
        require(success, "TV: Token transfer failed. Check allowance.");
        
        // Not: Gerçek hayatta, ilk yatırma anında unlockTime ayarlanır.
    }

    /**
     * @dev Kilit süresi dolduktan sonra token'ları çeker.
     */
    function withdrawTokens() public onlyOwner {
        // Kontrol: Kilit süresi doldu mu?
        require(block.timestamp >= unlockTime, "TV: Tokens are still locked");
        
        // Sözleşmedeki toplam token bakiyesini al
        uint256 balance = token.balanceOf(address(this));
        
        // Kontrol: Sözleşmenin token bakiyesi var mı?
        require(balance > 0, "TV: Vault is empty");

        // Tüm token'ları sahibine geri transfer et
        bool success = token.transfer(msg.sender, balance);
        require(success, "TV: Withdrawal transfer failed");
    }

    /**
     * @dev Kalan kilitleme süresini (saniye cinsinden) döndürür.
     * @return uint256 Kalan süre (eğer kilit süresi dolduysa 0 döner).
     */
    function getRemainingLockTime() public view returns (uint256) {
        if (block.timestamp >= unlockTime) {
            return 0;
        }
        return unlockTime - block.timestamp;
    }
}
