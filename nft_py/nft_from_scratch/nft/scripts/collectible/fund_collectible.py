from brownie import Collectible
from scripts.helpful_scripts import fund_collectible

def main():
    collectible = Collectible(len(Collectible)-1)
    fund_collectible(collectible)
    