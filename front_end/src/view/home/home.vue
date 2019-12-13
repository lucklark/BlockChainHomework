<template>
  <div>
    <Card>
      <h1>区块链金融中心</h1>
    </Card>
    <Card>
      <h2>当前合约信息</h2>
      <Row style = "margin: 10px 0">
        <Col span="4" style="text-align: right"><span>当前部署合约名称：</span>
        </Col>
        <Col span="8">{{ this.showData[this.nowIndex].name }}</Col>
      </Row>
      <Row style = "margin: 10px 0">
        <Col span="4" style="text-align: right"><span>当前部署合约地址：</span>
        </Col>
        <Col span="8">{{ this.showData[this.nowIndex].contractAddress }}</Col>
      </Row>
    </Card>
    <Card>
      <h2>合约操作</h2>
      <Row style = "margin: 10px 0">
        <Col span="5" offset = "3">
          <Button type="primary" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openAdd">重新部署合约</Button>
        </Col>
      </Row>
    </Card>
    <Card>
      <h2>账户操作</h2>
      <Row style = "margin: 10px 0">
        <Col span="10" offset = "3">
          <Button type="primary" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openCreate">创建公司</Button>
          <Button type="primary" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openTransaction">创建账单</Button>
          <Button type="primary" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openTransfer">转移账单</Button>
          <Button type="primary" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openSaleReceipt">出售账单</Button>
          <Button type="primary" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openRepayment">结清</Button>
        </Col>
      </Row>
    </Card>
    <Card>
      <h2>查询公司信息</h2>
      <Row style = "margin: 10px 0">
        <Col span="5" offset = "1">
          <Button type="primary" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openGetCompany">查询公司</Button>
        </Col>
      </Row>
      <Row style = "margin: 10px 0">
        <Col span="3" style="text-align: right"><span>公司地址：</span></Col>
        <Col span="2">{{ this.companyInfo[0] }}</Col>
        <Col span="3" style="text-align: right"><span>公司名称：</span></Col>
        <Col span="2">{{ this.companyInfo[1] }}</Col>
        <Col span="3" style="text-align: right"><span>公司账单数目：</span></Col>
        <Col span="2">{{ this.companyInfo[2] }}</Col>
        <Col span="3" style="text-align: right"><span>公司资金：</span></Col>
        <Col span="2">{{ this.companyInfo[3] }}</Col>
      </Row>
      <h2>查询公司账单</h2>
      <Row style = "margin: 10px 0">
        <Col span="5" offset = "1">
          <Button type="primary" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openGetReceipt">查询公司账单</Button>
        </Col>
      </Row>
      <Row style = "margin: 10px 0">
        <Col span="3" style="text-align: right"><span>债主公司：</span></Col>
        <Col span="2">{{ this.receiptInfo[0] }}</Col>
        <Col span="3" style="text-align: right"><span>借款公司：</span></Col>
        <Col span="2">{{ this.receiptInfo[1] }}</Col>
        <Col span="3" style="text-align: right"><span>欠款数目：</span></Col>
        <Col span="2">{{ this.receiptInfo[2] }}</Col>
      </Row>
    </Card>

  <Modal v-model="createCompany" title="添加公司">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="公司地址" prop="address" >
        <Input clearable v-model="addForm.address" placeholder = "请输入公司地址"/>
      </FormItem>
      <FormItem label="公司名称" prop="name" >
        <Input clearable v-model="addForm.name" placeholder = "请输入公司名称"/>
      </FormItem>
      <FormItem label="公司资产" prop="cash" >
        <Input clearable v-model="addForm.cash" placeholder = "请输入公司资产"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">取消</Button>
      <Button type="primary" @click="doAdd">确认</Button>
    </div>
  </Modal>

  <Modal v-model="isGetCompany" title="查询公司">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="公司地址" prop="address" >
        <Input  clearable v-model="addForm.address" placeholder = "请输入公司地址"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">取消</Button>
      <Button type="primary" @click="doAdd">确认</Button>
    </div>
  </Modal>

  <Modal v-model="isTransaction" title="添加账单">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="债主公司" prop="debtor" >
        <Input  clearable v-model="addForm.debtor" placeholder = "请输入债主公司地址"/>
      </FormItem>
      <FormItem label="借款公司" prop="borrower" >
        <Input  clearable v-model="addForm.borrower" placeholder = "请输入借款公司地址"/>
      </FormItem>
      <FormItem label="借款数" prop="cashNum" >
        <Input  clearable v-model="addForm.cashNum" placeholder = "请输入借款数"/>
      </FormItem>
      <FormItem label="限制还款时间(s)" prop="limitTime" >
        <Input  clearable v-model="addForm.limitTime" placeholder = "请输入限制还款时间"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">取消</Button>
      <Button type="primary" @click="doAdd">确认</Button>
    </div>
  </Modal>

  <Modal v-model="isTransfer" title="转移账单">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="原债主公司" prop="oriDebtor" >
        <Input  clearable v-model="addForm.oriDebtor" placeholder = "请输入原债主公司地址"/>
      </FormItem>
      <FormItem label="新债主公司" prop="newDebtor" >
        <Input  clearable v-model="addForm.newDebtor" placeholder = "请输入新债主公司地址"/>
      </FormItem>
      <FormItem label="借款公司" prop="borrower" >
        <Input  clearable v-model="addForm.borrower" placeholder = "请输入借款公司地址"/>
      </FormItem>
      <FormItem label="转移账单款数" prop="cashNum" >
        <Input  clearable v-model="addForm.cashNum" placeholder = "请输入转移账单款数"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">取消</Button>
      <Button type="primary" @click="doAdd">确认</Button>
    </div>
  </Modal>

  <Modal v-model="isSaleReceipt" title="出售账单">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="出售账单公司" prop="buyerAddr" >
        <Input  clearable v-model="addForm.buyerAddr" placeholder = "请输入出售账单公司地址"/>
      </FormItem>
      <FormItem label="出售账单款数" prop="cashNum" >
        <Input  clearable v-model="addForm.cashNum" placeholder = "请输入出售账单款数"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">取消</Button>
      <Button type="primary" @click="doAdd">确认</Button>
    </div>
  </Modal>

  <Modal v-model="isRepayment" title="结清账单">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="结清账单公司" prop="payerAddr" >
        <Input  clearable v-model="addForm.payerAddr" placeholder = "请输入结清账单公司地址"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">取消</Button>
      <Button type="primary" @click="doAdd">确认</Button>
    </div>
  </Modal>

  <Modal v-model="isGetReceipt" title="查询账单">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="查询账单公司" prop="address" >
        <Input  clearable v-model="addForm.address" placeholder = "请输入查询账单公司地址"/>
      </FormItem>
      <FormItem label="查询账单id" prop="index" >
        <Input  clearable v-model="addForm.index" placeholder = "请输入查询账单id"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">取消</Button>
      <Button type="primary" @click="doAdd">确认</Button>
    </div>
  </Modal>

  </div>
</template>

<script>
import axios from "@/libs/api.request";
export default {
  data() {
    return {
      showData: [{
        name:'',
        contractAddress:'',
      }],
      nowIndex: 0,
      createCompany: false,
      addForm: {},
      isGetCompany: false,
      isGetReceipt: false,
      isTransaction: false,
      isTransfer: false,
      isSaleReceipt: false,
      isRepayment: false,
      companyInfo: {},
      receiptInfo: {}
    }
    },
    methods:{
      async deploy(param) {
      let self = this
      let result = {}
      let da = {
        contractName: param,
      }
      await axios.request({
          url: "deploy",
          data: da,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
      }).then(function(res) {
          console.info(res.data);
          result = res.data
          self.showData.push({name: param,contractAddress: result.contractAddress});
      });
      },
      async addCompany(param) {
      let self = this
      let result = {}
      let judge = ""
      await axios.request({
          url: "addCompany",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
      }).then(function(res) {
          result = res.data
      });
      },
      async getCompany(param) {
      let self = this
      let result = {}
      let judge = ""
      await axios.request({
          url: "getCompany",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
      }).then(function(res) {
          console.info(res.data);
          result = res.data.output
          judge = res.data.status
      });
      if(judge == "0x0")
      {
        this.companyInfo = result;
        this.companyInfo[3] = parseInt(result[3],16);
        console.info(this.companyInfo[3])
      }
      else
      {
        this.companyInfo = {0:"无",1:"无",2:"0",3:"0"}
      }
      },
      async getReceipt(param) {
      let self = this
      let result = {}
      let judge = ""
      await axios.request({
          url: "getReceipt",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
      }).then(function(res) {
          console.info(res.data);
          result = res.data.output
          judge = res.data.status
      });
      if(judge == "0x0")
      {
        this.receiptInfo = result;
        this.receiptInfo[2] = parseInt(result[2],16);
      }
      else if(judge == "0xa")
      {
        this.receiptInfo = {0:"无",1:"无",2:"0"}
      }
      },
      async transaction(param) {
      let self = this
      let result = {}
      await axios.request({
          url: "transaction",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
      }).then(function(res) {
          console.info(res.data);
          result = res.data
      });
      },
      async transfer(param) {
      let self = this
      let result = {}
      await axios.request({
          url: "transfer",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
      }).then(function(res) {
          console.info(res.data);
          result = res.data
      });
      },
      async saleReceipt(param) {
      let self = this
      let result = {}
      await axios.request({
          url: "saleReceipt",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
      }).then(function(res) {
          console.info(res.data);
          result = res.data
      });
      },
      async repayment(param) {
      let self = this
      let result = {}
      await axios.request({
          url: "repayment",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
      }).then(function(res) {
          console.info(res.data);
          result = res.data
      });
      },
      openAdd(){
        this.deploy('Agency');
        this.nowIndex += 1;
      },
      openCreate(){
        this.createCompany = true;
        this.addForm.func = 'addCompany';
        this.addForm.addr = this.showData[this.nowIndex].contractAddress;
        this.addForm.contract = this.showData[this.nowIndex].name;
        this.addForm.name = '';
        this.addForm.address = '';
        this.addForm.cash = '';
        console.info(this.addForm)
      },
      openGetCompany(){
        this.isGetCompany = true;
        this.addForm.func = 'getCompany';
        this.addForm.addr = this.showData[this.nowIndex].contractAddress;
        this.addForm.contract = this.showData[this.nowIndex].name;
        this.addForm.address = '';
      },
      openTransaction(){
        this.isTransaction = true;
        this.addForm.func = 'transaction';
        this.addForm.addr = this.showData[this.nowIndex].contractAddress;
        this.addForm.contract = this.showData[this.nowIndex].name;
        this.addForm.debtor = '';
        this.addForm.borrower = '';
        this.addForm.cashNum = '';
        this.addForm.limitTime = '';
      },
      openTransfer(){
        this.isTransfer = true;
        this.addForm.func = 'transfer';
        this.addForm.addr = this.showData[this.nowIndex].contractAddress;
        this.addForm.contract = this.showData[this.nowIndex].name;
        this.addForm.oriDebtor = '';
        this.addForm.newDebtor = '';
        this.addForm.borrower = '';
        this.addForm.cashNum = '';
      },
      openSaleReceipt(){
        this.isSaleReceipt = true;
        this.addForm.func = 'saleReceipt';
        this.addForm.addr = this.showData[this.nowIndex].contractAddress;
        this.addForm.contract = this.showData[this.nowIndex].name;
        this.addForm.buyerAddr = '';
        this.addForm.cashNum = '';
      },
      openRepayment(){
        this.isRepayment = true;
        this.addForm.func = 'repayment';
        this.addForm.addr = this.showData[this.nowIndex].contractAddress;
        this.addForm.contract = this.showData[this.nowIndex].name;
        this.addForm.payerAddr = '';
      },
      openGetReceipt(){
        this.isGetReceipt = true;
        this.addForm.func = 'getReceipt';
        this.addForm.addr = this.showData[this.nowIndex].contractAddress;
        this.addForm.contract = this.showData[this.nowIndex].name;
        this.addForm.address = '';
        this.addForm.index = '';
      },
      cancelAdd(){
        this.$refs.addForm.resetFields();
        this.addForm = {}
        this.createCompany = false
        this.isGetCompany = false
        this.isTransaction = false
        this.isTransfer = false
        this.isSaleReceipt = false
        this.isRepayment = false
        this.isGetReceipt = false
      },
      doAdd(){
        console.info(this.addForm)
        if(this.addForm.func == 'addCompany')
        {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.name = this.addForm.name
          data.address = this.addForm.address
          data.cash = this.addForm.cash
          this.addCompany(data)
          this.$Message.success('添加公司成功')
        }
        else if(this.addForm.func == 'getCompany')
        {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.address = this.addForm.address
          console.info(data)
          this.getCompany(data)
          this.$Message.success('查询公司成功')
        }
        else if(this.addForm.func == 'transaction')
        {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.debtor = this.addForm.debtor
          data.borrower = this.addForm.borrower
          data.cashNum = this.addForm.cashNum
          data.limitTime = this.addForm.limitTime
          console.info(data)
          this.transaction(data)
          this.$Message.success('生成账单成功')
        }
        else if(this.addForm.func == 'transfer')
        {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.oriDebtor = this.addForm.oriDebtor
          data.newDebtor = this.addForm.newDebtor
          data.borrower = this.addForm.borrower
          data.cashNum = this.addForm.cashNum
          console.info(data)
          this.transfer(data)
          this.$Message.success('转移账单公司成功')
        }
        else if(this.addForm.func == 'saleReceipt')
        {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.buyerAddr = this.addForm.buyerAddr
          data.cashNum = this.addForm.cashNum
          this.saleReceipt(data)
          this.$Message.success('出售账单公司成功')
        }
        else if(this.addForm.func == 'repayment')
        {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.payerAddr = this.addForm.payerAddr
          this.repayment(data)
          this.$Message.success('结清账单公司成功')
        }
        else if(this.addForm.func == 'getReceipt')
        {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.address = this.addForm.address
          data.index = this.addForm.index
          this.getReceipt(data)
          this.$Message.success('查询账单公司成功')
        }
        this.cancelAdd();
      },
    },
    created () {
      this.nowIndex = 0;
    }
}
</script>

<style>
  span{
    font-weight:bold;
    font-size:25;
  }
</style>
