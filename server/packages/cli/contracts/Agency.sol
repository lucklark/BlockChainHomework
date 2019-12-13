pragma solidity ^0.4.21;

contract Agency{
	
	struct Company{ 
		uint256 companyAddr;//公司地址来确定对应的公司
		string companyName;//公司名字
		uint cashNum; //公司现金资产
	}

	struct Receipt{
		uint256 debtor;//借款公司地址
		uint256 borrower;//欠款公司地址
		uint totalNum;//欠款总额
		uint startTime; //账款创建日期
		uint limitTime;//期限时间
	}
	Receipt receipt;
	uint[] index;
	uint256 public financialAddr;
	mapping(uint256 => Receipt[]) public receiptList;
	mapping(uint256 => Company) public companyList;
	
	constructor(){
		financialAddr = 0x00;
		companyList[financialAddr] = Company({
			companyAddr: financialAddr,
			companyName: "Agency",
			cashNum: 100000
		});
	}
	
	function addCompany(uint256 addr, string name, uint cash) public returns (uint256) {
		uint256 ret_code = 0;
		companyList[addr] = Company({
			companyAddr: addr,
			companyName: name,
			cashNum: cash
		});
		return ret_code;
	}

	function getReceipt(uint256 addr, uint index)
		public
		returns (uint256, uint256, uint)
	{
		return (receiptList[addr][index].debtor,receiptList[addr][index].borrower, receiptList[addr][index].totalNum);
	}

	function getCompany(uint256 addr)
		public
		returns (uint256, string, uint, uint)
	{
		return (companyList[addr].companyAddr,companyList[addr].companyName, receiptList[addr].length,companyList[addr].cashNum);
	}

	function transaction(uint256 debtor, uint256 borrower, uint cashNum, uint limitTime) 
		public
		returns (uint256)
	{
		uint256 ret_code = 0;
		Receipt receipt;
		receipt.debtor = debtor;
		receipt.borrower = borrower;
		receipt.totalNum = cashNum;
		receipt.startTime = now;
		receipt.limitTime = limitTime;
		receiptList[debtor].push(receipt);
		receiptList[borrower].push(receipt);
		return ret_code;
	}

	function transfer(uint256 oriDebtor, uint256 newDebtor, uint256 borrower, uint cashNum) 
		public 
		returns (uint256)
	{
		uint256 ret_code = 0;
		if(newDebtor == borrower)//相同地址
		{
			ret_code = 1;
			return ret_code;
		}
		delete(index);
		uint ownNum = 0;
		uint i;
		uint k;
		for(i = 0; i < receiptList[oriDebtor].length; i++) {
			if((receiptList[oriDebtor][i].borrower == borrower) && (receiptList[oriDebtor][i].totalNum != 0)){
				index.push(i);//进行记录该借款者的款项
				ownNum += receiptList[oriDebtor][i].totalNum;
				if(ownNum >= cashNum)
				{
					break;
				}
			}
		}
		
		if(ownNum < cashNum)
		{
			ret_code = 2;
			return ret_code;
		}
		else if(ownNum == cashNum) {
			for(i = 0; i < index.length; i++) {
				receipt = receiptList[oriDebtor][index[i]];
				receipt.debtor = newDebtor;
				receiptList[oriDebtor][index[i]].totalNum = 0;//去除所有旧债主的债务
				receiptList[newDebtor].push(receipt);//加入新债主的映射中

				for(k = 0; k < receiptList[borrower].length; k ++) {//更新借款公司中的账单上的债主
					if(receiptList[borrower][k].debtor == oriDebtor && receiptList[borrower][k].totalNum == receipt.totalNum) {
						receiptList[borrower][k].debtor = newDebtor;
						break;
					}
				}
			}
		}
		else{
			for(i = 0; i < index.length-1; i++) {
				receipt = receiptList[oriDebtor][index[i]];
				receipt.debtor = newDebtor;
				receiptList[oriDebtor][index[i]].totalNum = 0;//去除所有旧债主的债务
				receiptList[newDebtor].push(receipt);//加入新债主的映射中

				for(k = 0; k < receiptList[borrower].length; k ++) {//更新借款公司中的账单上的债主
					if(receiptList[borrower][k].debtor == oriDebtor && receiptList[borrower][k].totalNum == receipt.totalNum) {
						receiptList[borrower][k].debtor = newDebtor;
						break;
					}
				}
			}

			receipt = receiptList[oriDebtor][index[index.length - 1]];

			for(k = 0; k < receiptList[borrower].length; k ++) {
				if(receiptList[borrower][k].debtor == oriDebtor && receiptList[borrower][k].totalNum == receipt.totalNum) {
					receiptList[borrower][k].totalNum = (ownNum - cashNum);
					break;
				}
			}
			receiptList[oriDebtor][index[index.length - 1]].totalNum = ownNum - cashNum;
			receipt.totalNum = cashNum + receipt.totalNum - ownNum;
			receipt.debtor = newDebtor;
			receiptList[newDebtor].push(receipt);//新持债公司加入新债
			receiptList[borrower].push(receipt);//借贷者加入新债
		}
		return ret_code;
	}
	
	function saleReceipt(uint256 buyerAddr,uint cashNum) 
		public
		returns (uint256)
	{
		uint256 ret_code = 0;
		delete(index);
		uint ownNum;
		uint i;
		uint j;
		for(j = 0; j < receiptList[buyerAddr].length; j ++){  
			ownNum += receiptList[buyerAddr][j].totalNum;
			index.push(j);
			if(ownNum >= cashNum){
				break;
			}
		}
		if(ownNum < cashNum)
		{
			ret_code = 1;
			return ret_code;
		}
		else if(ownNum == cashNum){
			for(i = 0; i < index.length; i++){
				transfer(buyerAddr, financialAddr, receiptList[buyerAddr][index[i]].borrower, receiptList[buyerAddr][index[i]].totalNum);
			}
		}
		else{
			for(i = 0; i < index.length - 1; i++){
				transfer(buyerAddr, financialAddr, receiptList[buyerAddr][index[i]].borrower, receiptList[buyerAddr][index[i]].totalNum);
			}
			transfer(buyerAddr, financialAddr, receiptList[buyerAddr][index.length - 1].borrower, receiptList[buyerAddr][index.length - 1].totalNum - (ownNum - cashNum));
		}
		companyList[buyerAddr].cashNum += cashNum;
		return ret_code;
	}
	
	function repayment(uint256 payerAddr) 
		public
		returns (uint256)
	{
		uint256 ret_code = 0;
		Receipt receipt; 
		uint i;
		for(i = 0; i < receiptList[payerAddr].length; i ++){
			receipt = receiptList[payerAddr][i];
			//判断是否到时间以及对应借款人是不是自己
			if(now >= receipt.startTime + receipt.limitTime && receipt.borrower == payerAddr){ 
				uint ownNum = companyList[payerAddr].cashNum;
				if(ownNum >= receipt.totalNum){
					companyList[payerAddr].cashNum -= receipt.totalNum;
					companyList[receipt.debtor].cashNum += receipt.totalNum;
					receiptList[payerAddr][i].totalNum = 0;

					for(uint k = 0; k < receiptList[receipt.debtor].length; k ++) {
						if((receiptList[receipt.debtor][k].borrower == payerAddr) && (receiptList[receipt.debtor][k].totalNum == receipt.totalNum)) {
							receiptList[receipt.debtor][k].totalNum = 0;
							break;
						}
					}
				}
				else{
					companyList[payerAddr].cashNum = 0;
					companyList[receipt.debtor].cashNum += ownNum;
					receiptList[payerAddr][i].totalNum -= ownNum;

					for(k = 0; k < receiptList[receipt.debtor].length; k ++) {
						if(receiptList[receipt.debtor][k].borrower == payerAddr && receiptList[receipt.debtor][k].totalNum == receipt.totalNum) {
							receiptList[receipt.debtor][k].totalNum -= ownNum;
							break;
						}
					}
				}
			}
		}
		return ret_code;
	}
}