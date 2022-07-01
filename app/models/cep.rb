require 'net/http'

class CEP 

    attr_reader :public_place, :neighbourhood, :local, :state

    def initialize(cep)

      cep_found = find(cep)
      fill_data(cep_found)

    end

    def full_address

        "#{public_place} / #{neighbourhood} / #{local} - #{state}"

    end

    private

        def find(cep)
            
            ActiveSupport::JSON.decode(

                Net::HTTP.get(

                    URI("http://viacep.com.br/ws/#{cep}/json/")

                )

            )

        end

        def fill_data(cep_found)

            @public_place = cep_found["logradouro"]
            @neighbourhood = cep_found["bairro"]
            @local = cep_found["localidade"]
            @state = cep_found["uf"]

        end

end