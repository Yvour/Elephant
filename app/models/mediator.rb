class Mediator
  @cookie
  @last_lead_id_list
  
  def get_last_lead_id_list
    return @last_lead_id_list
  end
  def get_cookie
    return @cookie
  end

  def perform_request(url, req_body, is_get=false)
    uri = URI(url)
    req_header= {
      'Content-Type' =>'application/json',
      'User-Agent'=>'amoCRM-API-client/1.0'};
    if @cookie.to_s.size > 0
      req_header['cookie'] = @cookie
    end
    p req_header
    Net::HTTP.start(uri.host, uri.port,
    :use_ssl => uri.scheme == 'https') do |http|
      request = '';
      if (is_get)
        request = Net::HTTP::Get.new uri
      else
        request = Net::HTTP::Post.new uri
      end

      request.initialize_http_header(req_header)

      request.body = req_body.to_json;
      response = http.request(request); # Net::HTTPResponse object
      if @cookie.to_s.length == 0
        @cookie = response.response['set-cookie']
      end
      return response
    end
  end

  def auth
    url = 'https://igelwald.amocrm.ru:443/private/api/auth.php?type=json';
    ar = {'USER_LOGIN'=>'igelwald@mail.ru',
      'USER_HASH'=>'300131161f6910e'}
    return perform_request(url, ar)
  end

  def new_task(contact_id, contact_comment, deal_id)
    url = 'https://igelwald.amocrm.ru:443/private/api/v2/json/tasks/set';
    prm = {:request=>{:tasks=>{
          :add=>[{
              :element_id => contact_id,
              :element_type => '1', # 1 контакт, 2 сделка, 3 компания
              :text => contact_comment,
              :task_type=> '1'
            },
            {
              :element_id => deal_id,
              :element_type => '2', # 1 контакт, 2 сделка, 3 компания
              :text => contact_comment,
              :task_type => '1'
            }
            ]
        }}}
    return perform_request(url, prm)

  end

  def get_contacts
    url = 'https://igelwald.amocrm.ru:443/private/api/v2/json/contacts/list';
    prm = {:type=>'contact'};
    prm = {}
    return perform_request(url, prm, true)
  end

  def new_lead(name, phone, email, comment)
    auth
    @last_lead_id_list == '';
    contact_id = JSON.parse(new_contact(name, email, phone).body)['response']['contacts']['add'][0]['id']
    p "contact_id #{contact_id}"
    deal_id = JSON.parse(new_deal(name).body)['response']['leads']['add'][0]['id']
    p "deal_id #{deal_id}"
    res =  JSON.parse(new_task(contact_id, comment, deal_id).body)
    p res
    @last_lead_id_list = res['response']['tasks']['add'].map{|x| x['id']}.join(', ')
    p "@last_lead_id_list is #{@last_lead_id_list}"
    return res
  end

  def new_deal(name)
    url = 'https://igelwald.amocrm.ru:443/private/api/v2/json/leads/set';
    prm = {:request=>{:leads=>{
          :add=>[{
              :name=>name,
              :status_id=>'1'

            }]
        }}}
    return perform_request(url, prm)
  end

  def new_contact(name, email, phone)
    url = 'https://igelwald.amocrm.ru:443/private/api/v2/json/contacts/set';
    prm = {:request=>{:contacts=>{
          :add=>[{:name=>name,

              :custom_fields => [
                {
                  :id=>458607,
                  :values=>[
                    :value=>phone,
                    :enum=>'OTHER'
                  ]
                },
                {:id=>458609,
                  :values=> [
                    :value=>email,
                    :enum=>'OTHER'
                  ]
                }
              ]

            }]
        }}}
    return perform_request(url, prm)
  end
end

