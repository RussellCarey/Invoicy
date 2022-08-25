module ApiHelper
    def authenticated_header(request, user)
        auth_headers = Devise::JWT::TestHelpers.auth_headers(response, user)
        request.headers['Authorization'] = auth_headers['Authorization'].split(' ')[1]
        request.headers.merge!(auth_headers)
    end
end