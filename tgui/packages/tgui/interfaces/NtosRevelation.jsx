import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosRevelation = (props) => {
  const { act, data } = useBackend();
  return (
    <NtosWindow width={400} height={250} theme="syndicate">
      <NtosWindow.Content>
        <Section>
          <Button.Input
            fluid
            content="Obfuscate Name..."
            onCommit={(e, value) =>
              act('PRG_obfuscate', {
                new_name: value,
              })
            }
            mb={1}
          />
          <LabeledList>
            <LabeledList.Item
              label="Payload Status"
              buttons={
                <Button
                  content={data.armed ? 'ARMED' : 'DISARMED'}
                  color={data.armed ? 'bad' : 'average'}
                  onClick={() => act('PRG_arm')}
                />
              }
            />
          </LabeledList>
          <Button
            fluid
            bold
            content="ACTIVATE"
            textAlign="center"
            color="bad"
            disabled={!data.armed}
          />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
