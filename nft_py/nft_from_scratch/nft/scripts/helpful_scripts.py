from brownie import Collectible, accounts, config, interface, network


def get_matatu(matatu_specs_number):
    switch = {0:'NGANYA',1:'MINIVAN',2:'BUS',3:'BIKE'}
    return switch[matatu_specs_number]

def fund_collectible(nft_contract):
    dev = accounts.add(config['wallets']['from_key'])
    link_token = interface.LinkTokenInterface(config['networks'][network.show_active()]['link_token'])
    link_token.transfer(nft_contract, 100000000000000000, {"from": dev})