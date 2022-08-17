const { ethers, network } = require("hardhat")
const fs = require("fs")

const frontendContractsFile = "../next-js-nft-marketplace/constants/networkMapping.json"

module.exports = async function () {
    if (process.env.UPDATE_FRONT_END) {
        console.log("updating frontend...")
        await updateContractAddresses()
    }
}

async function updateContractAddresses() {
    const nftMarketplace = await ethers.getContract("NftMarketplace")
    const chainId = network.config.chainId.toString()
    const contractAddresses = JSON.parse(fs.readFileSync(frontendContractsFile, "utf8"))
    if (chainId in contractAddresses) {
        if (!contractAddresses[chainId]["NftMarketplace"].includes(nftMarketplace.address)) {
            contractAddresses[chainId]["NftMarketplace"].push(nftMarketplace.address)
        }
    } else {
        contractAddresses[chainId] = { NftMarketplace: nftMarketplace.address }
    }
    fs.writeFileSync(frontendContractsFile, JSON.stringify(contractAddresses))
}

module.exports.tags = ["all", "frontend"]
