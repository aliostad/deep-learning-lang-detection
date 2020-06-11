class CalculatePaysController < ApplicationController
  before_action :clean_pay, only: [:index,:calculating_pay]
  before_action :calculating_pay, only: [:index]
  before_action :set_calculate_pay, only: [:show, :edit, :update, :destroy]
  @@time = Time.new
  # GET /calculate_pays
  # GET /calculate_pays.json
  def index
    @calculate_pays = CalculatePay.all
  end

  # GET /calculate_pays/1
  # GET /calculate_pays/1.json
  def show
  end

  # GET /calculate_pays/new
  def new
    @calculate_pay = CalculatePay.new
  end

  # GET /calculate_pays/1/edit
  def edit
  end

  # POST /calculate_pays
  # POST /calculate_pays.json
  def create
    @calculate_pay = CalculatePay.new(calculate_pay_params)

    respond_to do |format|
      if @calculate_pay.save
        format.html { redirect_to @calculate_pay, notice: 'Calculate pay was successfully created.' }
        format.json { render :show, status: :created, location: @calculate_pay }
      else
        format.html { render :new }
        format.json { render json: @calculate_pay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calculate_pays/1
  # PATCH/PUT /calculate_pays/1.json
  def update
    respond_to do |format|
      if @calculate_pay.update(calculate_pay_params)
        format.html { redirect_to @calculate_pay, notice: 'Calculate pay was successfully updated.' }
        format.json { render :show, status: :ok, location: @calculate_pay }
      else
        format.html { render :edit }
        format.json { render json: @calculate_pay.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calculate_pays/1
  # DELETE /calculate_pays/1.json
  def destroy
    @calculate_pay.destroy
    respond_to do |format|
      format.html { redirect_to calculate_pays_url, notice: 'Calculate pay was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calculate_pay
      @calculate_pay = CalculatePay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calculate_pay_params
      params.require(:calculate_pay).permit(:emp_id, :pay)
    end
    
    #임금 추출
    def calculating_pay
      
    @employee = Employee.all
    @timecards = TimeCard.all
    @sales_receipts = SalesReceipt.all
    @service_charges = ServiceCharge.all
    
    #월급쟁이
    @salaryman = @employee.where(payment_type: 'salary')
      @salaryman.each do |salaryman|
        service_charge= service_charges_calcualting(salaryman)
        salaryPay = salaryman.salary - salaryman.Dues - service_charge
        CalculatePay.create(emp_id: salaryman.emp_id, pay: salaryPay) #월급 - 조합원비 - 조합원서비스비용
      end
      
    #시급인생  
    @hourlyman = @employee.where(payment_type: 'hourly')
      @hourlyman.each do |hourlyman|
        service_charge= service_charges_calcualting(hourlyman)
        @someones_timecards = @timecards.where(emp_id: hourlyman.emp_id) #특정인의 타임카드수집
        totaltime = 0 #일한 종합시간 초기화
       
        @someones_timecards.each do |somecard| 
          
          if somecard.time >= 8
            totaltime += (somecard.time * 1.5) # 8시간 넘었을 때 시급 1.5배 추가(시간추가해줌)
          else
            totaltime += somecard.time 
          end
        end #특정인 총합
        
        hourlypay = hourlyman.hourly_rate * totaltime - hourlyman.Dues - service_charge #시급 * 총시간 - 조합원비 - 조합원서비스비용
         
        CalculatePay.create(emp_id: hourlyman.emp_id, pay: hourlypay)
      
      end  
      
    #수당인생
    @commisionman = @employee.where(payment_type: 'commision')
    @commisionman.each do |commisionman|
        service_charge= service_charges_calcualting(commisionman)
        @someones_sales_receipts = @sales_receipts.where(emp_id: commisionman.emp_id) #특정인의 판매 영수증
        commision = 0 #판매수량총합 초기화
        @someones_sales_receipts.each do |receipts| commision += receipts.amount end 
        @commisionpay = commisionman.commision_rate * commision + commisionman.salary - commisionman.Dues - service_charge #판매수량 * 수당비율 + 기본급 - 조합원비 - 조합원서비스비
        CalculatePay.create(emp_id: commisionman.emp_id, pay: @commisionpay)
      end  
    end
    
    def clean_pay #중복되는 레코드 삭제
      @calculate_pays = CalculatePay.all
      @calculate_pays.each do |pays| pays.destroy() end
    end
    
    
    def service_charges_calcualting(someone) #조합에 가입된 조합원의 서비스 charge 추출용 함수
        totalPee = 0
        @someones_service_charges = @service_charges.where(emp_id: someone.emp_id)
        @someones_service_charges.each do |service_charge| 
            totalPee+=service_charge.charge
        end
        return totalPee
    end
    
end

