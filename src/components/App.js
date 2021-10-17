import './App.css';
import Web3 from "web3";
import React, { Component } from "react";
import KryptoBird from "../contracts/abis/KryptoBird.json";
import detectEthereumProvider from "@metamask/detect-provider";
import { MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn } from 'mdb-react-ui-kit';

class App extends Component {

	constructor(props) {
		super(props);

		this.state = {
			account: '',
			contract: null,
			totalSupply: 0,
			kryptoBirdz: [],
		}
	}

	async componentDidMount() {
		await this.loadWeb3();
		await this.loadBlockchainData();
	}

	async loadWeb3() {
		const provider = await detectEthereumProvider();

		// Modern browsers
		if (provider) {
			console.log("Ethereum successfully detected!")
			console.log("Connected Provider", provider);
			window.ethereum = new Web3(provider);

			const chainId = await provider.request({
				method: 'eth_chainId'
			})
			console.log("ChainID", chainId);
		} else {
			console.error("Please install MetaMask!");
		}
	}

	async loadBlockchainData() {
		const web3 = window.ethereum;
		console.log("Web3", web3);

		const accounts = await web3.eth.getAccounts();
		this.setState({
			account: accounts[0]
		})

		const networkID = await web3.eth.net.getId();
		const networkData = KryptoBird.networks[networkID];

		if (networkData) {
			const contractAbi = KryptoBird.abi;
			const contractAddress = networkData.address;

			const contractInstance = new web3.eth.Contract(contractAbi, contractAddress);

			let totalSupply;
			await contractInstance.methods.totalSupply().call().then((total) => {
				totalSupply = total.toNumber();
			});

			for (let i = 0; i < totalSupply; i++) {
        const kryptoBird = await contractInstance.methods.kryptoBirdz(i).call();
				
				this.setState({
					kryptoBirdz: [...this.state.kryptoBirdz, kryptoBird]
				})
      }

			this.setState({
				contract: contractInstance,
				totalSupply
			})

			console.log("State Values", this.state);
		} else {
			console.error("Smart contract not deployed!");
		}
	}

	mint = (kryptoBird) => {
		this.state.contract.methods.mint(kryptoBird).send({
			from: this.state.account
		}).once('receipt', (receipt) => {
			console.log('Mint receipt', receipt);
			this.setState({
				kryptoBirdz: [...this.state.kryptoBirdz, kryptoBird]
			})
		})
	}

	render() {
		return(
			<main role='main' className='nft-container'>
				<nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
					<div className='navbar-brand col-sm-3 col-md-3 mr-0 text-white'>
						KryptoBirdz NFT Marketplace
					</div>
					<ul className='navbar-nav px-3'>
						<li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
							<small className='text-white'>{this.state.account}</small>
						</li>
					</ul>
				</nav>

				<section className='container-fluid'>
					<div className='row'>
						<div className='col-lg-12 d-flex text-center'>
							<div className='content mr-auto ml-auto' style={{ opacity: '0.8' }}>
								<h1>KryptoBirds - NFT Marketplace</h1>
								<form onSubmit={(event) => {
									event.preventDefault();

									const kryptoBird = this.kryptoBird.value;
									this.mint(kryptoBird)
								}}>
									<input
										type='text'
										placeholder="Add a file location"
										className='form-control mb-1'
										ref={(input) => this.kryptoBird = input}
									/>
									<input
										type='submit'
										value='MINT'
										className='btn btn-dark'
									/>
								</form>
							</div>
						</div>
					</div>
				</section>
				<hr></hr>
				<section className='container mt-5'>
					<div className='row text-center'>
						{this.state.kryptoBirdz.map((kryptoBird, key) => {
							return(
								<div itemID={key} className='col-lg-4 col-md-6 mb-3'>
									<MDBCard className='kbirdz-card' style={{ maxWidth: '22rem' }}>
										<MDBCardImage className='kbirdz-img' src={kryptoBird} position='top' alt={kryptoBird} />
										<MDBCardBody>
											<MDBCardTitle>KryptoBirdz</MDBCardTitle>
											<MDBCardText>
												The kryptoBirdz are uniquely generated KBirdz from the cyberpunk cloud galaxy Mystopia! There is only one of each birds owned by a single person on the Ethereum blockchain.
											</MDBCardText>
											<MDBBtn className='btn-dark' href={kryptoBird}>Download</MDBBtn>
										</MDBCardBody>
									</MDBCard>
								</div>
							);
						})}
					</div>
					
				</section>
			</main>
		);
	}
}

export default App;