# Onchain Supply Chain

This is a very simple implementation of a supply chain that can be used for tracking products onchain throughout the lifetime of the supply chain process.

There are three entities that help to categorize the process:

1. Product - Represents the actual product moving through the supply chain, which contains its unique product identifiers, the current owner, the current price of value in TruToken (a custom ERC20 token), and it's manufacturing timestamp.
2. Participant - Represents the particpants of the system, which are either "Manufacturer" or others. Only manufacturers can create new products
3. Registration - Represents the relationship between Product<>Participant. When a product moves along the supply chain, the Product is transferred from Participant to Participant, and a new Registration is created to represent this chain of custody.

There is a custom ERC20 token used to represent the value of each product, `TruToken`. It is a basic ERC20 that mints an initial supply of 1 Billion.

## Foundry

This is a foundry project without any frontend.
