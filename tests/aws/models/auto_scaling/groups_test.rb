Shindo.tests('AWS::AutoScaling | group', ['aws', 'auto_scaling_m']) do

  tests("asg creation") do
    params = {
      :id => uniq_id,
      :auto_scaling_group_name => "name",
      :availability_zones => [],
      :launch_configuration_name => uniq_id,
      :availability_zones => %w[us-east-1a]
    }

    lc_params = {
      :id => params[:launch_configuration_name],
      :image_id => "ami-3202f25b",
      :instance_type => "t1.micro",
    }

    lc = Fog::AWS[:auto_scaling].configurations.new(lc_params).save

    model_tests(Fog::AWS[:auto_scaling].groups, params, true) do
      @instance.update
    end

    lc.destroy
  end

  tests("instance list") do
    params = {
      :id => uniq_id,
      :auto_scaling_group_name => "name",
      :availability_zones => [],
      :launch_configuration_name => uniq_id,
      :availability_zones => %w[us-east-1a],
      'MaxSize' => 1,
      'DesiredCapacity' => 1
    }
    lc_params = {
      :id => params[:launch_configuration_name],
      :image_id => "ami-3202f25b",
      :instance_type => "t1.micro",
    }
    lc = Fog::AWS[:auto_scaling].configurations.new(lc_params).save
    asg = Fog::AWS[:auto_scaling].groups.create(params)

    sleep 10 if !Fog.mocking?
    asg.reload

    returns(1) { asg.instances.size }
    returns(params[:id]) { asg.instances.first.auto_scaling_group_name }
    returns(params[:launch_configuration_name]) { asg.instances.first.launch_configuration_name }

    asg.destroy(:force => true)
    lc.destroy
  end

end
