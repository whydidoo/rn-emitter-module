import React, {useEffect} from 'react';
import {View, StyleSheet, Button} from 'react-native';
import {RnEmitterModule} from '@whydidoo/rn-emitter-module';

function App(): React.JSX.Element {
  useEffect(() => {
    const id = RnEmitterModule.addNativeEventListener((event, data) => {
      console.log(event, data, 'JS');
    });

    return () => {
      RnEmitterModule.removeNativeEventListener(id);
    };
  }, []);

  return (
    <View style={styles.container}>
      <Button
        title="test press"
        onPress={() => RnEmitterModule.emitToNative('RNTEST')}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    fontSize: 40,
    color: 'green',
  },
});

export default App;
