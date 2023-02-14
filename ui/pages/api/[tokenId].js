export default function handler(req, res) {
    const tokenId = req.query.tokenId;
    const image_url = "https://github.com/imanmalhi/nft-collection-ui/tree/main/nft_images";
    
    res.status(200).json({
      name: "NFT #" + tokenId,
      description: "These NFTs are part of Iman's NFT Project.",
      image: image_url + tokenId + ".svg",
    });
  }