describe Exercise::Output::Pytest do
  describe '#summary' do
    let(:expected_summary) do
      <<~STRING
        ============================= test session starts ==============================
        platform linux2 -- Python 2.7.12, pytest-3.6.2, py-1.5.3, pluggy-0.6.0 -- /usr/bin/python
        cachedir: .pytest_cache
        rootdir: /vols/pytest_8357, inifile: pytest.ini
        plugins: testinfra-1.14.0
        collecting ... collected 4 items

        tests/webserver_test.py::test_apache_installed FAILED                    [ 25%]
        tests/webserver_test.py::test_apache_is_enabled_as_service FAILED        [ 50%]
        tests/webserver_test.py::test_apache_installed_is_running FAILED         [ 75%]
        tests/webserver_test.py::test_website_deployed FAILED                    [100%]
      STRING
    end
    let(:pytest_output) do
      <<~STRING
        #{expected_summary}
        =================================== FAILURES ===================================
        ____________________________ test_apache_installed _____________________________

        more output...

        /usr/local/lib/python2.7/dist-packages/paramiko/client.py:200: gaierror
        =========================== 4 failed in 0.27 seconds ===========================
      STRING
    end

    subject do
      described_class.new pytest_output
    end
    it 'returns the run summary' do
      expect(subject.summary).to eq(expected_summary.chomp)
    end
  end
end
