module Nominal
  module InvoiceAttributes
    class Payroll
      include Properties

      has_properties :employee_number,
                     :employee_curp,
                     :employee_regime_type_value,
                     :payment_date,
                     :initial_payment_date,
                     :final_payment_date,
                     :paid_days_number,
                     :payment_periodicity,
                     :employer_registration_number,
                     :social_security_number,
                     :department,
                     :clabe,
                     :bank,
                     :seniority,
                     :job_title,
                     :contract_type,
                     :workday_type,
                     :base_salary,
                     :job_risk,
                     :integrated_daily_wage,
                     :perceptions,
                     :deductions,
                     :incapacities,
                     :overtimes

      def to_xml(xml, precision = 2)

        #Check
        payroll_attr = get_attributes

        xml['nomina'].Nomina(payroll_attr) do

          #Check
          self.perceptions.to_invoice_xml(xml, precision) unless self.perceptions.nil?

          #Check
          self.deductions.to_invoice_xml(xml, precision) unless self.deductions.nil?

          #Check
          unless self.incapacities.nil? or !self.incapacities.is_a? Array or self.incapacities.empty?
            xml.Incapacidades(){
              self.incapacities.each do |incapacity|
                incapacity.to_xml(xml, precision)
              end
            }
          end

          #Check
          unless self.overtimes.nil? or !self.overtimes.is_a? Array or self.overtimes.empty?
            xml.HorasExtras(){
              self.overtimes.each do |overtime|
                overtime.to_xml(xml, precision)
              end
            }
          end

        end

        xml

      end

      private
      def get_attributes

        self.version ||= '1.1'

        payroll_attr = {}
        payroll_attr["xmlns:nomina"] = "http://www.sat.gob.mx/nomina"
        payroll_attr["xsi:schemaLocation"] = "http://www.sat.gob.mx/nomina http://www.sat.gob.mx/sitio_internet/cfd/nomina/nomina11.xsd"
        payroll_attr[:Version] = self.version
        payroll_attr[:NumEmpleado] = self.employee_number
        payroll_attr[:CURP] = self.employee_curp
        payroll_attr[:TipoRegimen] = self.employee_regime_type_value
        payroll_attr[:FechaPago] = self.payment_date
        payroll_attr[:FechaInicialPago] = self.initial_payment_date
        payroll_attr[:FechaFinalPago] = self.final_payment_date
        payroll_attr[:NumDiasPagados] = self.paid_days_number
        payroll_attr[:PeriodicidadPago] = self.payment_periodicity

        payroll_attr[:RegistroPatronal] = self.employer_registration_number unless self.employer_registration_number.nil?
        payroll_attr[:NumSeguridadSocial] = self.social_security_number unless self.social_security_number.nil?
        payroll_attr[:Departamento] = self.department unless self.department.nil?
        payroll_attr[:CLABE] = self.clabe unless self.clabe.nil?
        payroll_attr[:Banco] = self.bank unless self.bank.nil?
        payroll_attr[:FechaInicioRelLaboral] = self.employment_start_date unless self.employment_start_date.nil?
        payroll_attr[:Antiguedad] = self.seniority unless self.seniority.nil?
        payroll_attr[:Puesto] = self.job_title unless self.job_title.nil?
        payroll_attr[:TipoContrato] = self.contract_type unless self.contract_type.nil?
        payroll_attr[:TipoJornada] = self.workday_type unless self.workday_type.nil?
        payroll_attr[:SalarioBaseCotApor] = MoneyUtils.number_to_rounded_precision(self.base_salary, precision) unless self.base_salary.nil?
        payroll_attr[:RiesgoPuesto] = self.job_risk.value unless self.job_risk.nil?
        payroll_attr[:SalarioDiarioIntegrado] = MoneyUtils.number_to_rounded_precision(self.integrated_daily_wage, precision) unless self.integrated_daily_wage.nil?

      end

    end
  end
end