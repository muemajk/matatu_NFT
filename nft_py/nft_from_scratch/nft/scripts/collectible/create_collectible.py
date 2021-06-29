from brownie import Collectible, accounts, config
from scripts.helpful_scripts import get_matatu
import time

STATIC_SEED= 123

def main():
    dev = accounts.add(config['wallets']['from_key'])
    collectible = Collectible[len(Collectible) - 1]
    transaction = collectible.createMatatu(STATIC_SEED, "None", {"from":dev})
    transaction.wait(1)
    time.sleep(55)
    requestId = transaction.events['requestedCollectible']['requestId']
    token_id = collectible.requestIdToTokenId(requestId)
    matatu = get_matatu(collectible.tokenIdToMatatuSpecs(token_id))
    print(f'Matatu kind of token id {token_id} is {matatu}')
    