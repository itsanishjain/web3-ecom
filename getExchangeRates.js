// get the BTC price in USD and ETH form coingeko
const getExchangeRates = (cartTotal) => {
  let usd;
  let eth;

  console.log("CALLED.............", cartTotal);
  fetch("https://api.coingecko.com/api/v3/exchange_rates", {
    headers: {
      Accept: "application/json",
    },
  })
    .then((res) => {
      return res.json();
    })
    .then((data) => {
      console.log(data.rates);
      usd = data.rates.usd.value;
      eth = data.rates.eth.value;
      console.log(usd);
      console.log(eth);
      let ethAmount = (eth / usd) * cartTotal;
      console.log(ethAmount);
      
      // call checkout
      checkout(ethAmount);
    });

  const checkout = (ethAmount) => {
    console.log("GOT IT", ethAmount);
  };
};
