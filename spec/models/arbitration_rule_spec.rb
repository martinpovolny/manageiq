describe ArbitrationRule do
  describe '#operation' do
    it 'validates allowed actions' do
      expect { FactoryGirl.create(:arbitration_rule, :operation => 'skip') }
        .to raise_error(ActiveRecord::RecordInvalid, /Operation is not included in the list/)
    end
  end

  describe '#expression' do
    it 'requires an expression to be set' do
      expect { FactoryGirl.create(:arbitration_rule, :expression => nil) }
        .to raise_error(ActiveRecord::RecordInvalid, /Expression can't be blank/)
    end

    it 'serializes expression' do
      expression = MiqExpression.new('EQUAL' => { 'field' => 'User-userid', 'value' => 'admin' })
      rule = FactoryGirl.create(:arbitration_rule, :expression => expression)

      expect(rule.expression.kind_of?(MiqExpression)).to be_truthy
    end
  end

  describe '#name' do
    it 'requires a name' do
      expect { FactoryGirl.create(:arbitration_rule, :name => nil) }
        .to raise_error(ActiveRecord::RecordInvalid, /Name can't be blank/)
    end
  end

  describe '#get_by_rule_class' do
    it 'returns only rules of the given type' do
      user_rules = FactoryGirl.create_list(:arbitration_rule, 2)
      expression = MiqExpression.new('EQUAL' => {'field' => 'Blueprint-name', 'value' => 'test'})
      FactoryGirl.create(:arbitration_rule, :expression => expression)

      expect(ArbitrationRule.get_by_rule_class('User')).to eq(user_rules)
    end
  end
end
